module Tetrahedron
  module Databases
    class SQLite3 < Database::Provider
      class Configuration < Database::Configuration
        attr_accessor :path
      end

      def initialize
        @configuration = Configuration.new
        yield @configuration if block_given?
      end

      def connection
        @connection
      end

      def connect
        # If no path was specified, default to a transient in-memory database.
        @connection = Sequel.sqlite(:database => (@configuration.path || ':memory:'))
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
