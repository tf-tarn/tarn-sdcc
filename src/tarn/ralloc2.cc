// Philipp Klaus Krause, philipp@informatik.uni-frankfurt.de, pkk@spth.de, 2010 - 2018
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation; either version 2, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

// #define DEBUG_RALLOC_DEC // Uncomment to get debug messages while doing register allocation on the tree decomposition.
// #define DEBUG_RALLOC_DEC_ASS // Uncomment to get debug messages about assignments while doing register allocation on the tree decomposition (much more verbose than the one above).

#include "SDCCralloc.hpp"
#include "SDCCsalloc.hpp"

extern "C"
{
  #include "ralloc.h"
  #include "gen.h"
  float dryTarniCode (iCode *ic);
  bool tarn_assignment_optimal;
}

#define REG_R 0
#define REG_X 1

template <class I_t>
static void add_operand_conflicts_in_node(const cfg_node &n, I_t &I)
{
  const iCode *ic = n.ic;

  const operand *result = IC_RESULT(ic);
  const operand *left = IC_LEFT(ic);
  const operand *right = IC_RIGHT(ic);

  if(!result || !IS_SYMOP(result))
    return;

  // Todo: More fine-grained control for these.
  if (!(ic->op == '-' || ic->op == UNARYMINUS && !IS_FLOAT (operandType (left)) || ic->op == '~' ||
    ic->op == '^' || ic->op == '|' || ic->op == BITWISEAND))
    return;

  operand_map_t::const_iterator oir, oir_end, oirs;
  boost::tie(oir, oir_end) = n.operands.equal_range(OP_SYMBOL_CONST(result)->key);
  if(oir == oir_end)
    return;

  operand_map_t::const_iterator oio, oio_end;

  if(left && IS_SYMOP(left))
    for(boost::tie(oio, oio_end) = n.operands.equal_range(OP_SYMBOL_CONST(left)->key); oio != oio_end; ++oio)
      for(oirs = oir; oirs != oir_end; ++oirs)
        {
          var_t rvar = oirs->second;
          var_t ovar = oio->second;
          if(I[rvar].byte < I[ovar].byte)
            boost::add_edge(rvar, ovar, I);
        }

  if(right && IS_SYMOP(right))
    for(boost::tie(oio, oio_end) = n.operands.equal_range(OP_SYMBOL_CONST(right)->key); oio != oio_end; ++oio)
      for(oirs = oir; oirs != oir_end; ++oirs)
        {
          var_t rvar = oirs->second;
          var_t ovar = oio->second;
          if(I[rvar].byte < I[ovar].byte)
            boost::add_edge(rvar, ovar, I);
        }
}

// Return true, iff the operand is placed (partially) in r.
template <class G_t>
static bool operand_in_reg(const operand *o, reg_t r, const i_assignment_t &ia, unsigned short int i, const G_t &G)
{
  if(!o || !IS_SYMOP(o))
    return(false);

  if(r >= port->num_regs)
    return(false);

  operand_map_t::const_iterator oi, oi_end;
  for(boost::tie(oi, oi_end) = G[i].operands.equal_range(OP_SYMBOL_CONST(o)->key); oi != oi_end; ++oi)
    if(oi->second == ia.registers[r][1] || oi->second == ia.registers[r][0])
      return(true);

  return(false);
}

// Return true, iff the operand is placed in a reg.
template <class G_t>
static bool operand_byte_in_reg(const operand *o, int offset, reg_t r, const assignment &a, unsigned short int i, const G_t &G)
{
  if(!o || !IS_SYMOP(o))
    return(false);

  operand_map_t::const_iterator oi, oi2, oi3, oi_end;

  for(boost::tie(oi, oi_end) = G[i].operands.equal_range(OP_SYMBOL_CONST(o)->key); offset && oi != oi_end; offset--, oi++);

  if(oi == oi_end)
    return(false);

  return(a.global[oi->second] == r);
}

template <class G_t, class I_t>
static void set_surviving_regs(const assignment &a, unsigned short int i, const G_t &G, const I_t &I)
{
  iCode *ic = G[i].ic;

  bitVectClear(ic->rMask);
  bitVectClear(ic->rSurv);

  cfg_alive_t::const_iterator v, v_end;
  for (v = G[i].alive.begin(), v_end = G[i].alive.end(); v != v_end; ++v)
    {
      if(a.global[*v] < 0)
        continue;
      ic->rMask = bitVectSetBit(ic->rMask, a.global[*v]);

      if(!(IC_RESULT(ic) && IS_SYMOP(IC_RESULT(ic)) && OP_SYMBOL_CONST(IC_RESULT(ic))->key == I[*v].v))
        if(G[i].dying.find(*v) == G[i].dying.end())
          ic->rSurv = bitVectSetBit(ic->rSurv, a.global[*v]);
    }
}

template <class G_t, class I_t>
static void assign_operand_for_cost(operand *o, const assignment &a, unsigned short int i, const G_t &G, const I_t &I)
{
  if(!o || !IS_SYMOP(o))
    return;
  symbol *sym = OP_SYMBOL(o);
  operand_map_t::const_iterator oi, oi_end;
  for(boost::tie(oi, oi_end) = G[i].operands.equal_range(OP_SYMBOL_CONST(o)->key); oi != oi_end; ++oi)
    {
      var_t v = oi->second;
      if(a.global[v] >= 0)
        {
          sym->regs[I[v].byte] = tarn_regs + a.global[v];
          sym->nRegs = I[v].size;
        }
      else
        {
          sym->regs[I[v].byte] = 0;
          sym->nRegs = I[v].size;
        }
    }
}

template <class G_t, class I_t>
static void assign_operands_for_cost(const assignment &a, unsigned short int i, const G_t &G, const I_t &I)
{
  const iCode *ic = G[i].ic;

  if(ic->op == IFX)
    assign_operand_for_cost(IC_COND(ic), a, i, G, I);
  else if(ic->op == JUMPTABLE)
    assign_operand_for_cost(IC_JTCOND(ic), a, i, G, I);
  else
    {
      assign_operand_for_cost(IC_LEFT(ic), a, i, G, I);
      assign_operand_for_cost(IC_RIGHT(ic), a, i, G, I);
      assign_operand_for_cost(IC_RESULT(ic), a, i, G, I);
    }

  if(ic->op == SEND && ic->builtinSEND)
    assign_operands_for_cost(a, (unsigned short)*(adjacent_vertices(i, G).first), G, I);
}

// Check that the operand is either fully in registers or fully in memory. Todo: Relax this once code generation can handle partially spilt variables!
template <class G_t, class I_t>
static bool operand_sane(const operand *o, const assignment &a, unsigned short int i, const G_t &G, const I_t &I)
{
  if(!o || !IS_SYMOP(o))
    return(true);

  operand_map_t::const_iterator oi, oi_end;
  boost::tie(oi, oi_end) = G[i].operands.equal_range(OP_SYMBOL_CONST(o)->key);

  if(oi == oi_end)
    return(true);

  // In registers.
  if(std::binary_search(a.local.begin(), a.local.end(), oi->second))
    {
      while(++oi != oi_end)
        if(!std::binary_search(a.local.begin(), a.local.end(), oi->second))
          return(false);
    }
  else
    {
       while(++oi != oi_end)
        if(std::binary_search(a.local.begin(), a.local.end(), oi->second))
          return(false);
    }

  return(true);
}

template <class G_t, class I_t>
static bool inst_sane(const assignment &a, unsigned short int i, const G_t &G, const I_t &I)
{
  const iCode *ic = G[i].ic;

  return(operand_sane(IC_RESULT(ic), a, i, G, I) && operand_sane(IC_LEFT(ic), a, i, G, I) && operand_sane(IC_RIGHT(ic), a, i, G, I));
}

// Cost function.
template <class G_t, class I_t>
static float instruction_cost(const assignment &a, unsigned short int i, const G_t &G, const I_t &I)
{
  iCode *ic = G[i].ic;
  float c;

  wassert(TARGET_IS_TARN);
  wassert(ic);

  if(!inst_sane(a, i, G, I))
    return(std::numeric_limits<float>::infinity());

#if 0
  std::cout << "Calculating at cost at ic " << ic->key << ", op " << ic->op << " for: ";
  print_assignment(a);
  std::cout << "\n";
  std::cout.flush();
#endif

  if(ic->generated)
    {
#if 0
  std::cout << "Skipping, already generated.\n";
#endif
      return(0.0f);
    }

  // if(!Ainst_ok(a, i, G, I))
  //   return(std::numeric_limits<float>::infinity());

  // if(!Pinst_ok(a, i, G, I))
  //   return(std::numeric_limits<float>::infinity());

  switch(ic->op)
    {
    // Register assignment doesn't matter for these:
    case FUNCTION:
    case ENDFUNCTION:
    case LABEL:
    case GOTO:
    case INLINEASM:
#if 0
  std::cout << "Skipping, indepent from assignment.\n";
#endif
      return(0.0f);
    case '!':
    case '~':
    case UNARYMINUS:
    case '+':
    case '-':
    case '^':
    case '|':
    case BITWISEAND:
    case IPUSH:
    //case IPOP:
    case CALL:
    case PCALL:
    case RETURN:
    case '*':
    case '/':
    case '%':
    case '>':
    case '<':
    case LE_OP:
    case GE_OP:
    case EQ_OP:
    case NE_OP:
    case AND_OP:
    case OR_OP:
    //case GETABIT:
    //case GETBYTE:
    //case GETWORD:
    case LEFT_OP:
    case RIGHT_OP:
    case GET_VALUE_AT_ADDRESS:
    case SET_VALUE_AT_ADDRESS:
    case '=':
    case IFX:
    case ADDRESS_OF:
    case JUMPTABLE:
    case CAST:
    /*case RECEIVE:
    case SEND:*/
    case DUMMY_READ_VOLATILE:
    /*case CRITICAL:
    case ENDCRITICAL:*/
    case SWAP:
      assign_operands_for_cost(a, i, G, I);
      set_surviving_regs(a, i, G, I);
      c = dryTarniCode(ic);

      if (IC_RESULT (ic) && IS_ITEMP (IC_RESULT(ic)) && !OP_SYMBOL_CONST(IC_RESULT(ic))->remat && // Nudge towards saving RAM space. TODO: Do this in a better way, so it works for all backends!
        !operand_in_reg(IC_RESULT(ic), REG_R, a.i_assignment, i, G) && !operand_in_reg(IC_RESULT(ic), REG_X, a.i_assignment, i, G))
        c += 0.0001;

      ic->generated = false;
      // piCode(ic, stdout);
      // printf("Got cost %f\n", c);
      return(c);
    default:
      return(0.0f);
    }
}

// For early removal of assignments that cannot be extended to valid assignments. This is just a dummy for now.
template <class G_t, class I_t>
static bool assignment_hopeless(const assignment &a, unsigned short int i, const G_t &G, const I_t &I, const var_t lastvar)
{
  return(false);
}

// Increase chance of finding good compatible assignments at join nodes.
template <class T_t>
static void get_best_local_assignment_biased(assignment &a, typename boost::graph_traits<T_t>::vertex_descriptor t, const T_t &T)
{
  a = *T[t].assignments.begin();

  std::set<var_t>::const_iterator vi, vi_end;
  varset_t newlocal;
  std::set_union(T[t].alive.begin(), T[t].alive.end(), a.local.begin(), a.local.end(), std::inserter(newlocal, newlocal.end()));
  a.local = newlocal;
}

// Suggest to honor register keyword.
template <class G_t, class I_t>
static float rough_cost_estimate(const assignment &a, unsigned short int i, const G_t &G, const I_t &I)
{
  const i_assignment_t &ia = a.i_assignment;
  float c = 0.0f;

  if(ia.registers[REG_R][1] < 0)
    c += 0.05f;

  varset_t::const_iterator v, v_end;
  for(v = a.local.begin(), v_end = a.local.end(); v != v_end; ++v)
    {
      const symbol *const sym = (symbol *)(hTabItemWithKey(liveRanges, I[*v].v));
      if(a.global[*v] < 0 && !sym->remat) // Try to put non-rematerializeable variables into registers.
        c += 0.1f;
      if(a.global[*v] < 0 && IS_REGISTER(sym->type)) // Try to honour register keyword.
        c += 4.0f;
    }

  return(c);
}

// Code for another ic is generated when generating this one. Mark the other as generated.
static void extra_ic_generated(iCode *ic)
{
  iCode *ifx;

  // - can only jump on nonzero result for decrement of register / direct variable.
  if(ic->op == '-' && ic->next && ic->next->op == IFX && IC_COND (ic->next)->key == IC_RESULT(ic)->key)
    {
      ifx = ic->next;

      if ((!IS_ITEMP(IC_LEFT (ic)) || options.stackAuto || reentrant) && !isOperandGlobal (IC_LEFT (ic)))
        return;

      if (!IS_OP_LITERAL(IC_RIGHT(ic)))
        return;

      if (ullFromVal(OP_VALUE(IC_RIGHT(ic))) != 1)
        return;

      if (!isOperandEqual (IC_RESULT(ic), IC_LEFT(ic)))
        return;

      ifx->generated = true;
      return;
    }

  if(ic->op != EQ_OP && ic->op != NE_OP && ic->op != '<' && ic->op != '>' && ic->op != BITWISEAND)
    return;

  ifx = ifxForOp(IC_RESULT(ic), ic);

  if(!ifx)
    return;

  // Bitwise and code generation can only do the jump if there is at most one nonzero byte.
  if(ic->op == BITWISEAND)
    {
      int nonzero = 0;
      operand *const litop = IS_OP_LITERAL(IC_LEFT(ic)) ? IC_LEFT(ic) : IC_RIGHT(ic);

      if (!IS_OP_LITERAL(litop))
        return;

      for(unsigned int i = 0; i < getSize(operandType(IC_LEFT (ic))) && i < getSize(operandType(IC_RIGHT(ic))) && i < getSize(operandType(IC_RESULT(ic))); i++)
        if(byteOfVal(OP_VALUE(litop), i))
          nonzero++;

      if(nonzero > 1 && IC_FALSE (ifx))
        return;
    }

cnd:
  OP_SYMBOL(IC_RESULT(ic))->for_newralloc = false;
  OP_SYMBOL(IC_RESULT(ic))->regType = REG_CND;
  ifx->generated = true;
}

template <class T_t, class G_t, class I_t, class SI_t>
static bool tree_dec_ralloc(T_t &tree_decomposition, G_t &control_flow_graph, const I_t &conflict_graph, SI_t &spilt_conflict_graph)
{
  bool assignment_optimal;

  con2_t I2(boost::num_vertices(conflict_graph));
  for(unsigned int i = 0; i < boost::num_vertices(conflict_graph); i++)
    {
      I2[i].v = conflict_graph[i].v;
      I2[i].byte = conflict_graph[i].byte;
      I2[i].size = conflict_graph[i].size;
      I2[i].name = conflict_graph[i].name;
    }
  typename boost::graph_traits<I_t>::edge_iterator e, e_end;
  for(boost::tie(e, e_end) = boost::edges(conflict_graph); e != e_end; ++e)
    add_edge(boost::source(*e, conflict_graph), boost::target(*e, conflict_graph), I2);

  assignment ac;
  assignment_optimal = true;
  tree_dec_ralloc_nodes(tree_decomposition, find_root(tree_decomposition), control_flow_graph, I2, ac, &assignment_optimal);

  const assignment &winner = *(tree_decomposition[find_root(tree_decomposition)].assignments.begin());

#ifdef DEBUG_RALLOC_DEC
  std::cout << "Winner: ";
  for(unsigned int i = 0; i < boost::num_vertices(conflict_graph); i++)
    {
      std::cout << "(" << i << ", " << int(winner.global[i]) << ") ";
    }
  std::cout << "\n";
  std::cout << "Cost: " << winner.s << "\n";
  std::cout.flush();
#endif

  // Todo: Make this an assertion
  if(winner.global.size() != boost::num_vertices(conflict_graph))
    {
      std::cerr << "ERROR: No Assignments at root\n";
      exit(-1);
    }

  for(unsigned int v = 0; v < boost::num_vertices(conflict_graph); v++)
    {
      symbol *sym = (symbol *)(hTabItemWithKey(liveRanges, conflict_graph[v].v));
      bool spilt = false;

      if(winner.global[v] >= 0)
        sym->regs[conflict_graph[v].byte] = tarn_regs + winner.global[v];
      else
        {
          sym->regs[conflict_graph[v].byte] = 0;
          spilt = true;
        }

      if(spilt)
        tarnSpillThis(sym);

      sym->nRegs = conflict_graph[v].size;
    }

  for(unsigned int i = 0; i < boost::num_vertices(control_flow_graph); i++)
    set_surviving_regs(winner, i, control_flow_graph, conflict_graph);

  set_spilt(control_flow_graph, conflict_graph, spilt_conflict_graph);

  return(!assignment_optimal);
}

iCode *tarn_ralloc2_cc(ebbIndex *ebbi)
{
  eBBlock **const ebbs = ebbi->bbOrder;
  const int count = ebbi->count;
  iCode *ic;

#ifdef DEBUG_RALLOC_DEC
  std::cout << "Processing " << currFunc->name << " from " << dstFileName << "\n"; std::cout.flush();
#endif

  cfg_t control_flow_graph;

  con_t conflict_graph;

  ic = create_cfg(control_flow_graph, conflict_graph, ebbi);

  if(options.dump_graphs)
    dump_cfg(control_flow_graph);

  if(options.dump_graphs)
    dump_con(conflict_graph);

  tree_dec_t tree_decomposition;

  get_nice_tree_decomposition(tree_decomposition, control_flow_graph);

  alive_tree_dec(tree_decomposition, control_flow_graph);

  good_re_root(tree_decomposition);
  nicify(tree_decomposition);
  alive_tree_dec(tree_decomposition, control_flow_graph);

  if(options.dump_graphs)
    dump_tree_decomposition(tree_decomposition);

  guessCounts (ic, ebbi);

  scon_t spilt_conflict_graph;

  tarn_assignment_optimal = !tree_dec_ralloc(tree_decomposition, control_flow_graph, conflict_graph, spilt_conflict_graph);

  tarnRegFix (ebbs, count);

  if (reentrant)
    {
      chaitin_salloc(spilt_conflict_graph);

      if(options.dump_graphs)
        dump_scon(spilt_conflict_graph);
    }
  else
    doOverlays (ebbs, count);

  return(ic);
}
