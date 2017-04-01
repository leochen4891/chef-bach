node.set['bcpc']['hadoop']['graphite']['service_queries']['namenode'] = {
  'namenode.HeapMemoryUsage_committed' => {
     'query' => 'minSeries(jmx.namenode.*.memory.HeapMemoryUsage_committed)',
     'trigger_val' => "max(#{node['bcpc']['hadoop']['zabbix']['trigger_chk_period']}m)",
     'trigger_cond' => '=0',
     'trigger_name' => 'NameNodeAvailability',
     'enable' => true,
     'trigger_dep' => [],
     'trigger_desc' => 'Namenode service seems to be down',
     'severity' => 5,
     'route_to' => 'admin'
  },

  # Alarm when more than 30% of the datanodes are dead
  'namenode.DeadDataNodesRatio' => {
     'query' => 'divideSeries('\
                  'minSeries(jmx.namenode.*.nn_fs_name_system_state.FSNamesystemState.NumDeadDataNodes),'\
                  'maxSeries(jmx.namenode.*.nn_fs_name_system_state.FSNamesystemState.Num*DataNodes)'\
                ')',
     'trigger_val' => "max(#{node['bcpc']['hadoop']['zabbix']['trigger_chk_period']}m)",
     'trigger_cond' => '>0',
     'trigger_name' => 'DeadDataNodesRatio',
     'enable' => true,
     'trigger_dep' => [],
     'trigger_desc' => 'More than 30% datanodes are dead',
     'severity' => 3,
     'route_to' => 'admin',
     'esc_period' => '60'
  },

  # Alarm when namenodes report different non-zero number of dead datanodes after 10.5(default) min
  'namenode.DeadDataNodesNumbersMismatch' => {
     'query' => 'diffSeries(removeBelowValue(jmx.namenode.*.nn_fs_name_system_state.FSNamesystemState.NumDeadDataNodes,1))',
     'trigger_val' => "max(#{node['bcpc']['hadoop']['zabbix']['trigger_chk_period']}m)",
     'trigger_cond' => '>0',
     'trigger_name' => 'DeadDataNodesNumbersMismatch',
     'enable' => true,
     'trigger_dep' => [],
     'trigger_desc' => 'Namenodes report different non-zero numbers of dead datanodes',
     'severity' => 2,
     'route_to' => 'admin',
     'esc_period' => '630'
  }
}
