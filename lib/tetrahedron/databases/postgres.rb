module Tetrahedron
  module Databases
    class Postgres < Database::Provider
      class Configuration < Database::Configuration
        attr_accessor :host,
                      :port,
                      :user,
                      :password,
                      :database,
                      :pool
      end

      def initialize(&configurator)
        @configuration = Configuration.new
        @configuration.instance_eval(&configurator) if block_given?
      end

      def connection
        @connection
      end

      def connect
        # Wait some amount of time before assuming the database is down.
        Service.wait_until_reachable!(:protocol => :tcp,
                                      :host => @configuration.host,
                                      :port => @configuration.port,
                                      :timeout => 15)

        @connection = Sequel.postgres(:host => @configuration.host,
                                      :port => @configuration.port,
                                      :user => @configuration.user,
                                      :password => @configuration.password,
                                      :database => @configuration.database,
                                      :test => true,
                                      :sslmode => :prefer,
                                      :max_connections => @configuration.pool)

        true
      end

      def disconnect
        @connection.disconnect if @connection
        @connection = nil
        true
      end
    end
  end
end
