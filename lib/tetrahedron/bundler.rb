require 'rubygems'
require 'bundler'

module Tetrahedron
  module Bundler
    def self.require
      ::Bundler.require(:default, :assets, :db, :redis, Tetrahedron.env.to_sym)
    end
  end
end
