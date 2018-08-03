name             'bcpc-hadoop'
maintainer       'Bloomberg Finance L.P.'
maintainer_email 'hadoop@bloomberg.net'
license          'Apache License 2.0'
description      'Installs/Configures Bloomberg Clustered Private Hadoop Cloud (BCPHC)'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.3.21'

depends 'bcpc', '= 3.3.21'
depends 'bach_krb5', '= 3.3.21'
depends 'smoke-tests', '= 3.3.21'
depends 'bach_opentsdb', '= 3.3.21'
depends 'database'
depends 'java'
depends 'poise'
depends 'pam'
depends 'sysctl'
depends 'ulimit'
depends 'locking_resource'
