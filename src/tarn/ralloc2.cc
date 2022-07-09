#include "SDCCralloc.hpp"

extern "C"
{
  #include "ralloc.h"
  #include "gen.h"
}

// Code for another ic is generated when generating this one. Mark the other as generated.
static void extra_ic_generated(iCode *ic) {}
template <class I_t>
static void add_operand_conflicts_in_node(const cfg_node &n, I_t &I) {}


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

  return ic;

  // tree_dec_t tree_decomposition;

  // get_nice_tree_decomposition(tree_decomposition, control_flow_graph);

  // alive_tree_dec(tree_decomposition, control_flow_graph);

  // good_re_root(tree_decomposition);
  // nicify(tree_decomposition);
  // alive_tree_dec(tree_decomposition, control_flow_graph);

  // if(options.dump_graphs)
  //   dump_tree_decomposition(tree_decomposition);

  // guessCounts (ic, ebbi);

  // scon_t spilt_conflict_graph;

  // pdk_assignment_optimal = !tree_dec_ralloc(tree_decomposition, control_flow_graph, conflict_graph, spilt_conflict_graph);

  // pdkRegFix (ebbs, count);

  // if (reentrant)
  //   {
  //     chaitin_salloc(spilt_conflict_graph);

  //     if(options.dump_graphs)
  //       dump_scon(spilt_conflict_graph);
  //   }
  // else
  //   doOverlays (ebbs, count);

  // return(ic);
}
