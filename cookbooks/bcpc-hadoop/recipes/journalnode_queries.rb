triggers_sensitivity = "60m"

node.set[:bcpc][:hadoop][:graphite][:service_queries][:journalnode] = {
  'journalnode.LastWrittenTxId' => {
     'query' => "rangeOfSeries(jmx.journalnode.dnj2-bach-*.journal_node.Journal-DNJ2-JR.LastWrittenTxId)",
     'trigger_val' => "min(#{trigger_sensitivity})",
     'trigger_cond' => ">0",
     'trigger_name' => "JournalNodeLastWrittenTxId",
     'enable' => true,
     'trigger_desc' => "JournalNodes have different LastWrittenTxId for #{trigger_sensitivity}",
     'severity' => 3,
     'route_to' => "admin"
  }
}
