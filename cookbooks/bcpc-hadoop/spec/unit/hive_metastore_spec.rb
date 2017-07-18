require 'chef'
require 'cheffish/rspec/chef_run_support'
require_relative '../../libraries/hive_metastore'

describe 'hive_metastore_database' do
  extend Cheffish::RSpec::ChefRunSupport

  let :resource do
    recipe do
      hive_metastore_database "run #{the_action}" do
        root_password 'therootpassword'
        hive_password 'thehivepassword'
        schematool_path '/the/path/to/schematool'
        action the_action
      end
    end.resources.first
  end

  let :provider do
    resource.provider_for_action the_action
  end

  describe '#create' do
    let(:the_action) { :create }

    it 'checks if the database is created' do
      allow(provider).to receive(:create_hive_database)

      expect(provider).to receive(:database_created?)
      provider.run_action :create
    end

    it 'creates the database' do
      allow(provider).to receive(:database_created?).and_return(false)

      expect(provider).to receive(:create_hive_database)
      provider.run_action :create
    end

    it 'marks the resource as updated' do
      allow(provider).to receive(:database_created?).and_return(false)
      allow(provider).to receive(:create_hive_database)

      provider.run_action :create

      expect(resource).to be_updated
    end

    describe '#database_created?' do
      it 'shells out to mysql to with the root password' do
        expect(Mixlib::ShellOut).to receive(:new)
          .with(/mysql -uroot -ptherootpassword -e /)
          .and_return(Mixlib::ShellOut.new)
        provider.database_created?
      end
    end

    describe '#create_hive_database' do
      it 'passes the mysqlcommand to create the database' do
        privs = 'SELECT,INSERT,UPDATE,DELETE,LOCK TABLES,EXECUTE'
        stdin = <<-eos
CREATE DATABASE metastore;
GRANT #{privs} ON metastore.* TO 'hive'@'%' IDENTIFIED BY 'thehivepassword';
GRANT #{privs} ON metastore.* TO 'hive'@'localhost' IDENTIFIED BY 'thehivepassword';
FLUSH PRIVILEGES;
        eos

        expect(Mixlib::ShellOut).to receive(:new)
          .with(/mysql -uroot -ptherootpassword/, hash_including(input: stdin))
          .and_return(Mixlib::ShellOut.new)

        provider.create_hive_database
      end
    end

    context 'when the database is already created' do
      it 'doesn\'t create the database' do
        allow(provider).to receive(:database_created?).and_return(true)

        expect(provider).to_not receive(:create_hive_database)
        provider.run_action :create
      end

      it 'doesn\'t update the resource' do
        allow(provider).to receive(:database_created?).and_return(true)

        provider.run_action :create
        expect(resource).to_not be_updated
      end
    end
  end

  describe '#init' do
    let(:the_action) { :init }

    it 'marks the resource as updated' do
      allow(provider).to receive(:schema_initialized?).and_return(false)
      provider.run_action :init

      expect(resource).to be_updated
    end

    describe '#schema_initalized?' do
      it 'shells out to schematool' do
        expect(Mixlib::ShellOut).to receive(:new).and_return(double.as_null_object)
          .with('/the/path/to/schematool -dbType mysql -info')

        provider.run_action :init
      end

      it 'interprets the schematool output' do
        fake_shellout = double
        allow(fake_shellout).to receive(:run_command)
        allow(fake_shellout).to receive(:stdout)
        allow(fake_shellout).to receive(:stderr).and_return(<<-eos)
org.apache.hadoop.hive.metastore.HiveMetaException: Failed to get schema version.
Underlying cause: com.mysql.jdbc.exceptions.jdbc4.MySQLSyntaxErrorException : Table 'metastore.VERSION' doesn't exist
SQL Error code: 1146
Use --verbose for detailed stacktrace.
*** schemaTool failed ***
        eos
        allow(Mixlib::ShellOut).to receive(:new).and_return(fake_shellout)

        expect(provider).to_not be_schema_initialized
      end
    end

    context 'when the database already has a schema' do
      it 'doesn\'t update the resource' do
        fake_shellout = double
        allow(fake_shellout).to receive(:run_command)
        allow(fake_shellout).to receive(:stdout).and_return(<<-eos)
Metastore connection URL:        jdbc:mysql:loadbalance://bcpc-vm1.bcpc.example.com:3306,bcpc-vm2.bcpc.example.com:3306/metastore?loadBalanceBlacklistTimeout=5000
Metastore Connection Driver :    com.mysql.jdbc.Driver
Metastore connection User:       root
Hive distribution version:       1.2.1000
Metastore schema version:        1.2.0
        eos
        allow(fake_shellout).to receive(:stderr).and_return(<<-eos)
Java HotSpot(TM) 64-Bit Server VM warning: Cannot open file /var/log/hive/gc/gc.log-9311-bcpc-vm2-201707181116.log due to Permission denied

Java HotSpot(TM) 64-Bit Server VM warning: Cannot open file /var/log/hive/gc/gc.log-9311-bcpc-vm2-201707181116.log due to Permission denied

2017-07-18 11:16:06,856 WARN  [main] conf.HiveConf: HiveConf of name hive.server2.logging.operation.verbose does not exist
org.apache.hadoop.hive.metastore.HiveMetaException: Metastore schema version is not compatible. Hive Version: 1.2.1000, Database Schema Version: 1.2.0
Use --verbose for detailed stacktrace.
*** schemaTool failed ***
        eos
        allow(Mixlib::ShellOut).to receive(:new).and_return(fake_shellout)

        provider.run_action :init

        expect(resource).to_not be_updated
      end
    end
  end
end
