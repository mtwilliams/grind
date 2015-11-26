module Tetrahedron
  module Database
    class Configuration
      Options = %i{adapter user password host port database pool}
      attr_reader *Options

      def initialize(configuration={})
        Options.each do |opt|
          self.instance_variable_set(:"@#{opt}", configuration[opt])
        end
      end

      def override(overrides={})
        configuration = self.dup
        Options.each do |opt|
          configuration.instance_variable_set(:"@#{opt}", overrides[opt]) if overrides.include? opt
        end
        configuration
      end
    end

    def self.configured?
      !@configuration.nil?
    end

    def self.configure(configuration)
      # TODO(mtwilliams): Validate |configuration|.
      configuration[:database] ||= Terahedron.config.app.to_s.underscore.gsub(/::/,'_')
      configuration[:pool] ||= 1
      @configuration = Configuration.new(configuration)
    end

    # TODO(mtwilliams): Refactor into Terahedron::Service.wait_until_reachable
    def self.wait_until_reachable(overrides={})
      # By default, we wait up to 15 seconds.
      overrides[:timeout] ||= 15

      configuration   = @configuration.override(overrides) if configured?
      configuration ||= Configuration.new(overrides)

      # TODO(mtwilliams): Don't assume TCP.
       # Look at |configuration.adapter|.
      Timeout::timeout(overrides[:timeout]) do
        while true
          begin
            TCPSocket.new(configuration.host, configuration.port).close
            return true
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
            # We're all good citizens, right?
            Kernel.sleep(1)
          end
        end
      end
    rescue Timeout::Error
      false
    end

    def self.wait_until_reachable!(overrides={})
      # TODO(mtwilliams): Raise a custom exception type.
      raise "Database is unreachable!" unless wait_until_reachable
    end

    def self.connect(overrides={})
      # Wait some amount of time before assuming the database is down.
      Tetrahedron::Database.wait_until_reachable!(overrides)

      configuration   = @configuration.override(overrides) if configured?
      configuration ||= Configuration.new(overrides)

      @connection = Sequel.connect(:adapter => configuration.adapter,
                                   :user => configuration.user,
                                   :password => configuration.password,
                                   :host => configuration.host,
                                   :port => configuration.port,
                                   :database => configuration.database,
                                   :test => true,
                                   :sslmode => :prefer,
                                   :max_connections => configuration.pool)

      # Reback our models with the new connection pool.
      Tetrahedron::Model.db = @connection

      true
    end

    def self.disconnect
      connection = @connection

      # TODO(mtwilliams): Ensure this is thread safe.
      # Make sure no one tries to use the disconnected connection pool.
      Tetrahedron::Model.db = Sequel.mock
      @connection = nil

      connection.disconnect unless connection.nil?
    end

    def self.connection
      @connection
    end

    def self.reset
      # TODO(mtwilliams): Drop and recreate database.
    end

    def self.migrate
      Sequel::IntegerMigrator.run(connection, File.join(Tetrahedron.config.root, 'db', 'migrations'))
    end

    def self.seed
      Kernel.load(File.join(Tetrahedron.config.root, 'db', 'seed.rb'))
    end
  end
end
