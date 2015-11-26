module Tetrahedron
  Model = Class.new(Sequel::Model)

  # Stop Sequel from bitching if it's subclassed before the first database
  # connection is established.
  Model.db = Sequel.mock if Sequel::DATABASES.empty?

  class Model
    def self::db=(db)
      super(db)

      # All the way down, boys.
      self.descendents.each do |subclass|
        subclass.db = db
      end
    end
  end

  def self::Model(source)
    unless Sequel::Model::ANONYMOUS_MODEL_CLASSES.key?(source)
      anonymous_model_class = nil
      if source.is_a?(Sequel::Database)
        anonymous_model_class = Class.new(Tetrahedron::Model)
        anonymous_model_class.db = source
      else
        anonymous_model_class = Class.new(Tetrahedron::Model).set_dataset(source)
      end
      Sequel::Model::ANONYMOUS_MODEL_CLASSES[source] = anonymous_model_class
    end
    return Sequel::Model::ANONYMOUS_MODEL_CLASSES[source]
  end
end
