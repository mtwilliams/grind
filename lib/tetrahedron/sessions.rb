module Tetrahedron
  class Sessions
    class Configuration
      OPTIONS = [:key, :domain, :path, :expires, :secret]
      attr_accessor *OPTIONS
      def dsl(&block)
        config = self
        dsl = Class.new
        OPTIONS.each do |option|
          dsl.send :define_method, option.to_sym do |value|
            config.instance_variable_set(:"@#{option}", value)
          end
        end
        dsl.new.instance_eval(&block)
      end
    end

    def self.configure(&configurator)
      application = self.class_variable_get(:@@application)
      configuration = Configuration.new
      configuration.key = (application.to_s.underscore.split('::')+['session']).join('.')
      configuration.dsl(&configurator)
      middleware = application.const_get('Middleware')
      middleware.use(Rack::Session::Cookie, :key => configuration.key,
                                            :domain => configuration.domain,
                                            :path => configuration.path,
                                            :expire_after => configuration.expires,
                                            :secret => configuration.secret)
    end

    def self.install(application)
      sessions = Class.new(self)
      application.const_set('Sessions', sessions)
      sessions.class_variable_set(:@@application, application)
    end
  end
end
