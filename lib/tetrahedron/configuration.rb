module Tetrahedron
  class Configuration
    DEFAULT = "config/tetrahedron.rb"

    attr_reader :app
    attr_reader :root

    def initialize()
      # TODO(mtwilliams): Best guess @app and @root.
    end

    def self.load(filename=Tetrahedron::Configuration::DEFAULT)
      configuration = Tetrahedron::Configuration.new
      DomainSpecificLanguage.for(configuration).instance_eval(File.read(filename), filename)
      configuration
    end

    class DomainSpecificLanguage
      def initialize(configuration)
        @configuration = configuration
      end

      def app(name)
        @configuration.instance_variable_set(:@app, name)
      end

      def root(directory)
        raise Tetrahedron::MisconfiguredError.new(:root, 'the path given does not exist') unless File.exist?(directory)
        raise Tetrahedron::MisconfiguredError.new(:root, 'the path given is not a directory') unless File.directory?(directory)
        @configuration.instance_variable_set(:@root, directory)
      end

      def self.for(configuration)
        DomainSpecificLanguage.new(configuration)
      end
    end
  end

  def self.config(path=Tetrahedron::Configuration::DEFAULT)
    @configuration ||= begin
      Configuration.load(path)
    end
  end
end
