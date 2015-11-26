require 'rubygems'
require 'bundler'

Bundler.require(:default)

# Some things aren't nicely cut gems, unforunately.
require 'base64'
require 'erb'
require 'net/http'
require 'ostruct'
require 'securerandom'
require 'socket'
require 'time'
require 'uri'
require 'yaml'

# Smells like Rails...
require 'active_support'
require 'active_support/core_ext'

module Tetrahedron
  def self.root
    @root ||= File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end
end

require 'tetrahedron/gem'
require 'tetrahedron/bundler'

require 'tetrahedron/error'
require 'tetrahedron/errors'

require 'tetrahedron/configuration'
require 'tetrahedron/environment'
require 'tetrahedron/bootfile'

Tetrahedron::Bundler.require

require 'sinatra/base'
require 'sinatra/contrib'

require 'sequel'

Sequel.extension :migration

Sequel::Model.plugin :timestamps
Sequel::Model.plugin :subclasses

require 'tetrahedron/base'

require 'tetrahedron/assets'

require 'tetrahedron/database'
require 'tetrahedron/sessions'

require 'tetrahedron/app'
require 'tetrahedron/model'
require 'tetrahedron/controller'
require 'tetrahedron/endpoint'
