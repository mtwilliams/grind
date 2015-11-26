require_relative 'application'
require_relative 'environment'

rackup      File.join(Tetrahedron.root, 'config', 'app.ru')

environment Tetrahedron.env.to_s
bind        "tcp://#{ENV['HOST'] || '0.0.0.0'}:#{ENV['PORT'] || 80}"
port        (ENV['PORT'] || 80).to_i
workers     (ENV['PUMA_WORKERS'] || 1).to_i
threads     (ENV['PUMA_MIN_THREADS'] || 1).to_i,
            (ENV['PUMA_MAX_THREADS'] || 1).to_i

preload_app!

before_fork do
  if Tetrahedron.env.production?
    # TODO(mtwilliams): Precompile assets.
    Tetrahedron::Assets.precompile
  end
end

on_worker_boot do
  Tetrahedron.bootfile.up.call() if Tetrahedron.bootfile.up
end

# TODO(mtwilliams): Report low-level errors in production.
 # lowlevel_error_handler do |e|
 #   ...
 # end
