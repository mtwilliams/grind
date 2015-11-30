module Tetrahedron
  class Application
    class Base < Tetrahedron::Base
      def self.inherited(base)
        super(base)
        base.send :define_singleton_method, :inherited do |basee|
          super(basee)
          basee.set :application, Proc.new { basee.to_s.split('::')[0..-2].join('::').constantize }
          basee.set :environment, Proc.new { application.environment.to_sym }
          basee.set :root, Proc.new { application.root }
        end
      end
    end
  end
end

