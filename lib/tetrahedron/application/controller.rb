module Tetrahedron
  class Application
    class Controller < Tetrahedron::Application::Base
      set :views, Proc.new { "#{root}/app/#{application.name.underscore}/views" }

      # Recognize *.html.erb as Erubis templates.
      Tilt.register Tilt::ErubisTemplate, 'html.erb'

      # Don't recognize *.erb templates.
      def erb(template, options={}, locals={})
        options[:layout] = settings.erb[:layout] if options[:layout].nil?
        render 'html.erb', template, options, locals
      end
    end
  end
end
