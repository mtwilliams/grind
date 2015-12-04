require 'sinatra/base'
require 'sinatra/contrib/all'

module Tetrahedron
  class Application < Tetrahedron::Base
    def self.env
      components = self.to_s.upcase.split('::')
      possibilities = (components.size.downto(1).map{|n| components.first(n).join('_')+'_ENV'})
      environments = (possibilities+['RACK_ENV']).map{|possibility| ENV[possibility]}
      @env ||= ::ActiveSupport::StringInquirer.new(environments.reject(&:nil?).first || 'development')
    end

    set :environment, Proc.new { self.env.to_sym }
    set :root, Dir.pwd

    # Don't use the built-in web-server.
    set :run, false

    def self.inherited(application)
      super(application)

      Tetrahedron::Middleware.install(application)
      Tetrahedron::Sessions.install(application)

      application.const_set('Controller', Class.new(Controller))
      application.const_set('Endpoint', Class.new(Endpoint))

      Tetrahedron::Database.install(application)
    end
  end
end
