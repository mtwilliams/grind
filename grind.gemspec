$:.push File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'grind/gem'

Gem::Specification.new do |s|
  s.name              = Grind::Gem.name
  s.version           = Grind::Gem.version
  s.platform          = Gem::Platform::RUBY
  s.author            = Grind::Gem.author.name
  s.email             = Grind::Gem.author.email
  s.homepage          = Grind::Gem.homepage
  s.summary           = Grind::Gem.summary
  s.description       = Grind::Gem.description
  s.license           = Grind::Gem.license

  s.required_ruby_version = '>= 2.2.3'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.require_paths = %w(lib)

  s.add_development_dependency("rake")
  s.add_development_dependency("pry")
  s.add_development_dependency("thor")
end
