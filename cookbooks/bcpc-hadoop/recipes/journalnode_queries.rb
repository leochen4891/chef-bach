triggers_sensitivity = '60m'

node.set[:bcpc][:hadoop][:graphite][:service_queries][:journalnode] = {
  'journalnode.LastWrittenTxId' => {
     'query' => "rangeOfSeries(jmx.journalnode.dnj2-bach-*.journal_node.Journal-DNJ2-JR.LastWrittenTxId)",
     'trigger_val' => "min(#{triggers_sensitivity})",
     'trigger_cond' => ">0",
     'trigger_name' => "JournalNodeLastWrittenTxId",
     'enable' => true,
     'trigger_desc' => "Journal nodes have different LastWrittenTxId for #{triggers_sensitivity}",
     'severity' => 3,
     'route_to' => "admin"
  },
  'journalnode.LastPromisedEpoch' => {
     'query' => "rangeOfSeries(jmx.journalnode.dnj2-bach-*.journal_node.Journal-*.LastPromisedEpoch)",
     'trigger_val' => "min(#{triggers_sensitivity})",
     'trigger_cond' => ">0",
     'trigger_name' => "JournalNodeLastPromisedEpoch",
     'enable' => true,
     'trigger_desc' => "Journal nodes have different LastPromisedEpoch for #{triggers_sensitivity}",
     'severity' => 3,
     'route_to' => "admin"
  }
}
