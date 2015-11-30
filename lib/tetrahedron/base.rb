require 'sinatra/base'
require 'sinatra/contrib/all'

module Tetrahedron
  class Base < Sinatra::Base
    # Errors are bubbled so they can be handled by middleware.
    set :dump_errors, false
    set :raise_errors, true
    set :show_exceptions, false

    # Fuck you, IE9.
    disable :method_override

    # TODO(mtwilliams): Re-enable basic protections, like traversal.
    disable :protection

    # Let users handle serving static files.
    disable :static

    # Hot-reload in development.
    register Sinatra::Reloader
  end
end
