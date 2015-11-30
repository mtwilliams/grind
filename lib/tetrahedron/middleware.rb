module Tetrahedron
  class Middleware
    def self.use(middleware, *args, &block)
      stack = self.class_variable_get(:@@stack)
      stack << proc { |app| middleware.new(app, *args, &block) }
      self.class_variable_set(:@@stack, stack)
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      middlewares = self.class.class_variable_get(:@@stack).reverse
      wrapped = middlewares.inject(@app) {|_, middleware| middleware[_]}
      wrapped.call(env)
    end

    def self.install(application)
      middleware = Class.new(self)
      application.const_set('Middleware', middleware)
      middleware.class_variable_set(:@@stack, [])
    end
  end
end
