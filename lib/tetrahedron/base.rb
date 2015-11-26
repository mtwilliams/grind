module Tetrahedron
  class Base < Sinatra::Base
    set :environment, Tetrahedron.env.to_sym
    set :root, Tetrahedron.config.root

    # Don't use the built-in web-server.
    set :run, false

    # Errors are bubbled so they can be handled by middleware.
    set :dump_errors, false
    set :raise_errors, true
    set :show_exceptions, false

    # Fuck you, IE9.
    disable :method_override

    configure :development do
      # King of iteration, baby.
      register Sinatra::Reloader
    end

    configure do
      disable :static
    end

    get '/*' do
      # Try to serve statically first.
      server = Rack::Static.new(proc {[404, {}, []]}, root: File.join(Tetrahedron.config.root, '/public'))
      status, headers, response = server.call(env)
      pass if status == 404
      [status, headers, response]
    end
  end
end
