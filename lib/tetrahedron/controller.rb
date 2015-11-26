module Tetrahedron
  class Controller < Tetrahedron::Base
    set :views, File.join(Tetrahedron.config.root, 'app', Tetrahedron.config.app.underscore, 'views')

    # Use app/<app>/views/_layouts/default as the default layout.
    set :erb, :layout => :'_layouts/default'

    # Recognize *.html.erb as Erubis templates.
    Tilt.register Tilt::ErubisTemplate, 'html.erb'

    # Don't recognize *.erb templates.
    def erb(template, options={}, locals={})
      options[:layout] = settings.erb[:layout] if options[:layout].nil?
      render 'html.erb', template, options, locals
    end
  end
end
