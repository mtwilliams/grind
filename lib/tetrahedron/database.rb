require 'sequel'

# Everyone needs these.
Sequel.extension :migration
Sequel::Model.plugin :timestamps

# The Tet needs this for the magic performed in `Model.db=`.
Sequel::Model.plugin :subclasses

module Tetrahedron
  class Database < Service
    class Configuration < Service::Configuration
    end

    class Provider < Service::Provider
      def connection; end
      def connect; raise NotImplementedError; end
      def disconnect; raise NotImplementedError; end
    end

    def self.connected?
      !self.connection.nil?
    end

    def self.connection
      configured!
      self.class_variable_get(:@@provider).connection
    end

    def self.connect
      configured!
      connected = self.class_variable_get(:@@provider).connect
      # Back our models with the new connection.
      model = self.class_variable_get(:@@application).const_get("Model")
      model.db = self.connection if connected
      connected
    end

    def self.disconnect
      configured!
      # TODO(mtwilliams): Verify that this is thread-safe.
      model = self.class_variable_get(:@@application).const_get("Model")
      model.db = Sequel.mock
      self.class_variable_get(:@@provider).disconnect
    end

    def self.install(application)
      super(application)

      # TODO(mtwilliams): Refactor out this horrid mess.

      # We can't build an inheritence heirarchy.
      # See https://groups.google.com/d/msg/sequel-talk/OG5ti9JAJIE/p1iqO57cwqwJ.
      application.class_eval("Model = Class.new(Sequel::Model);")
      model = application.const_get("Model")

      # Stop Sequel from bitching when we users subclass models before the
      # database connection is established.
      model.db = Sequel.mock

      # Back descendents.
      model.send :define_singleton_method, :db= do |db|
        super(db)
        # All the way down, boys.
        self.descendents.each do |descendent|
          descendent.db = db
        end
      end

      # Custom names are cool, m'kay.
      application.send :define_singleton_method, :Model do |source|
        anonymous_model_class = model::ANONYMOUS_MODEL_CLASSES_MUTEX.synchronize do
                                  model::ANONYMOUS_MODEL_CLASSES[source]
                                end
        unless anonymous_model_class
          anonymous_model_class = if source.is_a?(Sequel::Database)
                                    Class.new(model).db = source
                                  else
                                    Class.new(model).set_dataset(source)
                                  end
          model::ANONYMOUS_MODEL_CLASSES_MUTEX.synchronize do
            model::ANONYMOUS_MODEL_CLASSES[source] = anonymous_model_class
          end
        end
        anonymous_model_class
      end
    end
  end
end
