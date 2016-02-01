module Tetrahedron
  class Service
    def self.install(application)
      service = Class.new(self)
      service.class_variable_set(:@@application, application)
      application.const_set(self.to_s.split('::').last, service)
    end

    Unconfigured = Class.new(Tetrahedron::Error)
    Misconfigured = Class.new(Tetrahedron::Error)
    AlreadyConfigured = Class.new(Tetrahedron::Error)

    class Configuration
    end

    def self.configured?
      self.class_variable_defined?(:@@provider)
    end

    def self.configured!
      raise Unconfigured unless self.configured?
    end

    def self.configure(&configurator)
      raise AlreadyConfigured if self.configured?
      provider = configurator.call()
      raise Misconfigured unless provider.is_a? Provider
      self.class_variable_set(:@@provider, provider)
    end

    Unreachable = Class.new(Tetrahedron::Error)

    class Provider
    end

    def self.wait_until_reachable(opts={})
      Timeout::timeout(opts.fetch(:timeout, 15)) do
        while true
          begin
            case opts[:protocol]
            when :tcp
              TCPSocket.new(opts[:host], opts[:port]).close
              return true
            when :udp
              raise "This makes no sense!"
            end
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
            # We're all good citizens, right?
            Kernel.sleep(1)
          end
        end
      end
    rescue Timeout::Error
      false
    end

    def self.wait_until_reachable!(opts={})
      unless self.wait_until_reachable(opts)
        $stderr.puts "Unable to reach #{opts[:host]}:#{opts[:port]}!"
        raise Unreachable
      end
    end
  end
end
