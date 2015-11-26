# TODO(mtwilliams): Better multitenancy.

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'tetrahedron'

require File.join(Tetrahedron.config.root, "config", "application")

Tetrahedron::Configuration.load
