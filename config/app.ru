#!/usr/bin/env rackup

require_relative 'application'
require_relative 'environment'

# TODO(mtwilliams): Request tracking (make Heroku compatiable).
# TODO(mtwilliams): Performance monitoring (make Heroku compatiable).
# TODO(mtwilliams): Error handling.

if Tetrahedron::Sessions.configured?
  use Rack::Session::Cookie, :key => Tetrahedron::Sessions.config.cookie,
                             :domain => Tetrahedron::Sessions.config.domain,
                             :expire_after => Tetrahedron::Sessions.config.lifetime,
                             :secret => Tetrahedron::Sessions.config.secret
else
  # TODO(mtwilliams): Use a logger.
  $stderr.puts "Sessions not configured!\n => Use Tetrahedron::Sessions.configure in config/environment.rb!"
end

# TODO(mtwilliams): Remove cylcical dependency so we can use a constantized version.
run Tetrahedron.config.app.constantize
