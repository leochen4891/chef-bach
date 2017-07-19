default['bcpc']['hadoop']['jmxtrans_agent']['collectIntervalInSeconds'] = 15
default['bcpc']['hadoop']['jmxtrans_agent']['outputWriter']['class'] = 'org.jmxtrans.agent.GraphitePlainTextTcpOutputWriter'
default['bcpc']['hadoop']['jmxtrans_agent']['outputWriter']['host'] = node['bcpc']['management']['vip']
default['bcpc']['hadoop']['jmxtrans_agent']['outputWriter']['port'] = node['bcpc']['graphite']['relay_port']

# HDFS namenode
default['bcpc']['hadoop']['jmxtrans_agent']['namenode']['queries'] = [
  {
    'objectName' => '',
    'resultAlias' => '',
    'attributes' => ''
  }
]

# HDFS datanode
default['bcpc']['hadoop']['jmxtrans_agent']['datanode']['xml'] = '/etc/hadoop/conf/jmxtrans_agent_datanode.xml'
default['bcpc']['hadoop']['jmxtrans_agent']['datanode']['namePrefix'] = 'jmx.hdfs.datanode'
default['bcpc']['hadoop']['jmxtrans_agent']['datanode']['queries'] = [
  {
    'objectName' => 'Hadoop:name=JvmMetrics,service=DataNode',
    'resultAlias' => 'dn_jvm_metrics',
    'attributes' =>
        'GcCount,' \
        'GcTimeMillis,' \
        'LogError,' \
        'LogFatal,' \
        'LogInfo,' \
        'LogWarn,' \
        'MemHeapCommittedM,' \
        'MemHeapUsedM,' \
        'MemMaxM,' \
        'MemNonHeapCommittedM,' \
        'MemNonHeapUsedM,' \
        'ThreadsBlocked,' \
        'ThreadsNew,' \
        'ThreadsRunnable,' \
        'ThreadsTerminated,' \
        'ThreadsTimedWaiting,' \
        'ThreadsWaiting'
  },
  {
    'objectName' => 'Hadoop:name=DataNodeInfo,service=DataNode',
    'resultAlias' => 'dn_data_node_info',
    'attributes' =>
        'ClusterId,' \
        'HttpPort,' \
        'NamenodeAddresses,' \
        'RpcPort,' \
        'Version,' \
        'VolumeInfo,' \
        'XceiverCount'
  }
]

# HBase master
default['bcpc']['hadoop']['jmxtrans_agent']['hbase_ms']['queries'] = [
  {
    'objectName' => '',
    'resultAlias' => '',
    'attributes' => ''
  }
]

# HBase region server
default['bcpc']['hadoop']['jmxtrans_agent']['hbase_rs']['queries'] = [
  {
    'objectName' => '',
    'resultAlias' => '',
    'attributes' => ''
  }
]
