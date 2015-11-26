module Tetrahedron
  module Environment
    # Loads `ENV` from `.env` if available.
    def self.load
      # TODO(mtwilliams): Use a proper logger.
      $stdout.puts "Loading environment from `.env` if available..."
      require 'dotenv'
      Dotenv.load! File.join(Tetrahedron.config.root, '.env')
      $stdout.puts " => Loaded from `.env`."
    rescue LoadError => _
      $stderr.puts " => The 'dotenv' Gem is not available on this system."
      false
    rescue Errno::ENOENT
      $stderr.puts " => No `.env' file."
      false
    end
  end

  def self.env
    env = ENV["#{Tetrahedron.config.app.upcase.gsub(/::/,'_')}_ENV"] || ENV['TETRAHEDRON_ENV'] || ENV['RACK_ENV']
    @env ||= ::ActiveSupport::StringInquirer.new(env)
  end

  def self.env=(new_environment)
    ENV["#{Tetrahedron.config.app.upcase.gsub(/::/,'_')}_ENV"] = ENV['TETRAHEDRON_ENV'] = new_environment
    @env = ::ActiveSupport::StringInquirer.new(new_environment)
  end
end
