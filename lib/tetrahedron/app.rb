module Tetrahedron
  class App < Tetrahedron::Base
    configure do
      environment = Tetrahedron::Assets::Environment.new
      set :assets, environment: environment
      sprockets_based_server = Tetrahedron::Assets::Server.new(settings.assets[:environment])
      set :assets, server: sprockets_based_server
    end

    get %r{^/assets/*} do
      # Assets are handled by Sprockets.
      env['PATH_INFO'].sub('/assets', '')
      settings.assets[:server].call!(env)
    end
  end
end
