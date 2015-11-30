$:.push File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'tetrahedron/gem'

Gem::Specification.new do |s|
  s.name              = Tetrahedron::Gem.name
  s.version           = Tetrahedron::Gem.version
  s.platform          = Gem::Platform::RUBY
  s.author            = Tetrahedron::Gem.author.name
  s.email             = Tetrahedron::Gem.author.email
  s.homepage          = Tetrahedron::Gem.homepage
  s.summary           = Tetrahedron::Gem.summary
  s.description       = Tetrahedron::Gem.description
  s.license           = Tetrahedron::Gem.license

  s.required_ruby_version = '>= 2.2.3'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.require_paths = %w(lib)

  s.add_development_dependency("rake")
  s.add_development_dependency("pry")

  s.add_dependency("thor")

  s.add_dependency("activesupport")

  s.add_dependency("rack")
  s.add_dependency("rack-contrib")
  s.add_dependency("sinatra")
  s.add_dependency("sinatra-contrib")
  s.add_dependency("erubis")

  s.add_dependency("sequel")
  s.add_dependency("redis")
  s.add_dependency("mail")
end
