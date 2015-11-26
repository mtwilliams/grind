module Tetrahedron
  class Bootfile
    DEFAULT = "config/boot.rb"

    attr_reader :up
    attr_reader :down

    def initialize()
      # TODO(mtwilliams): Provide reasonable defaults.
    end

    def self.load(filename=Tetrahedron::Bootfile::DEFAULT)
      bootfile = Tetrahedron::Bootfile.new
      require File.join(Tetrahedron.root, "config", "application")
      DomainSpecificLanguage.for(bootfile).instance_eval(File.read(filename), filename)
      bootfile
    end

    class DomainSpecificLanguage
      def initialize(bootfile)
        @bootfile = bootfile
      end

      def up(&block)
        @bootfile.instance_variable_set(:@up, block)
      end

      def down(&block)
        @bootfile.instance_variable_set(:@down, block)
      end

      def self.for(bootfile)
        DomainSpecificLanguage.new(bootfile)
      end
    end
  end

  def self.bootfile(path=Tetrahedron::Bootfile::DEFAULT)
    @bootfile ||= begin
      Bootfile.load(path)
    end
  end
end
