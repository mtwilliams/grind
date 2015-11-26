require_relative 'application'

Tetrahedron::Environment.load

if Tetrahedron.env.development?
  # Synchronize STDOUT and STDERR to make debugging easier.
  STDOUT.sync = STDERR.sync = true
end

require File.join(Tetrahedron.config.root, "config", "environment")

unless Tetrahedron::Database.configured?
  $stderr.puts "Database not configured!\n => Use Tetrahedron::Database.configure in config/environment.rb!"
end

# unless Tetrahedron::Redis.configured?
#   $stderr.puts "Redis not configured!\n => Use Tetrahedron::Redis.configure in config/environment.rb!"
# end
