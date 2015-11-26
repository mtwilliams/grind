module Tetrahedron
  module Assets
    class Environment < Sprockets::Environment
      def initialize
        super(Tetrahedron.config.root)

        self.append_path('vendor/assets/styles')
        self.append_path('vendor/assets/scripts')
        self.append_path('vendor/assets/fonts')
        self.append_path('vendor/assets/images')

        self.append_path('assets/styles')
        self.append_path('assets/scripts')
        self.append_path('assets/fonts')
        self.append_path('assets/images')

        if Tetrahedron.env.production?
          self.css_compressor = CSSminify.new
          self.js_compressor = Uglifier.new
        end
      end
    end

    class Server
      def initialize(environment)
        @environment = environment
      end

      def call(env)
        @environment.call(env)
      end
    end

    class Precompiler
      # Precompile.
    end

    def self.precompile
      # TODO(mtwilliams): Implement asset precompilation.
      $stderr.puts "Asset precompilation is not implemented yet!"
    end
  end
end
