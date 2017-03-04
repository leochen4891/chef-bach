node.set['bcpc']['hadoop']['graphite']['service_queries']['namenode'] = {
  'namenode.HeapMemoryUsage_committed' => {
     'query' => "minSeries(jmx.namenode.*.memory.HeapMemoryUsage_committed)",
     'trigger_val' => "max(#{node["bcpc"]["hadoop"]["zabbix"]["trigger_chk_period"]}m)",
     'trigger_cond' => "=0",
     'trigger_name' => "NameNodeAvailability",
     'enable' => true,
     'trigger_dep' => [],
     'trigger_desc' => "Namenode service seems to be down",
     'severity' => 5,
     'route_to' => "admin"
  },

  # Alarm when more than 30% of the datanodes are dead, TODO immediately
  'namenode.DeadNodesRatio' => {
     'query' => 'divideSeries('\
                  'minSeries(jmx.namenode.*.nn_fs_name_system_state.FSNamesystemState.NumDeadDataNodes),'\
                  'maxSeries(jmx.namenode.*.nn_fs_name_system_state.FSNamesystemState.Num*DataNodes)'\
                ')',
     'trigger_val' => "max(#{node["bcpc"]["hadoop"]["zabbix"]["trigger_chk_period"]}m)",
     'trigger_cond' => '>0.3',
     'trigger_name' => "DeadNodesRatio",
     'enable' => true,
     'trigger_dep' => [],
     'trigger_desc' => "More than 30% datanodes are dead",
     'severity' => 5,
     'route_to' => "admin"
  },

  # Alarm when namenodes report different non-zero number of dead datanodes after 10.5(default) min
  'namenode.DeadNodesMismatch' => {
     'query' => 'diffSeries(removeBelowValue(jmx.namenode.*.nn_fs_name_system_state.FSNamesystemState.FilesTotal,1))',
     'trigger_val' => "max(#{node["bcpc"]["hadoop"]["zabbix"]["trigger_chk_period"]}m)",
     'trigger_cond' => '>0',
     'trigger_name' => "DeadNodesMismatch",
     'enable' => true,
     'trigger_dep' => [],
     'trigger_desc' => "Namenodes report different non-zero numbers of dead datanodes",
     'severity' => 3,
     'route_to' => "admin"
  }
}
