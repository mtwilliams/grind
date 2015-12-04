module Tetrahedron
  module Databases
    class SQLite3 < Database::Provider
      class Configuration < Database::Configuration
        attr_accessor :path
      end

      def initialize(&configurator)
        @configuration = Configuration.new
        # TODO(mtwilliams): Invoke such that users don't have to prepend |self|.
        @configuration.instance_eval(&configurator) if block_given?
      end

      def connection
        @connection
      end

      def connect
        # If no path was specified, default to a transient in-memory database.
        puts "Connecting to SQlite3 database at #{@configuration.path}"
        @connection = Sequel.sqlite(@configuration.path)
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
