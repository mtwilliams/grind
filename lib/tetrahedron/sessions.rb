module Tetrahedron
  module Sessions
    class Configuration
      Options = %i{cookie domain lifetime secret}
      attr_reader *Options

      def initialize(configuration={})
        Options.each do |opt|
          self.instance_variable_set(:"@#{opt}", configuration[opt])
        end
      end
    end

    def self.config
      @configuration
    end

    def self.configured?
      !@configuration.nil?
    end

    def self.configure(configuration)
      # TODO(mtwilliams): Validate |configuration|.
      configuration[:cookie] ||= "#{Tetrahedron.config.app.to_s.downcase.gsub(/::/,'.')}.session"
      @configuration = Sessions::Configuration.new(configuration)
    end
  end
end
