module Tetrahedron
  module Rake
    def self.install
      root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
      require_relative 'configuration'
      Tetrahedron::Configuration.load
      require_relative 'environment'
      Tetrahedron::Environment.load
      require File.join(root, 'config', 'application')
      require File.join(root, 'config', 'environment')
      Dir.glob(File.join(root, 'lib', 'tetrahedron', 'tasks', '**.rake')).each do |path|
        Kernel.load(path)
      end
    end
  end
end
