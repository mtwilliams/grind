require 'active_support'
require 'active_support/core_ext'

module Tetrahedron
  require 'tetrahedron/gem'
  require 'tetrahedron/error'

  require 'tetrahedron/middleware'
  require 'tetrahedron/sessions'

  require 'tetrahedron/base'
    require 'tetrahedron/application'
      require 'tetrahedron/application/base'
        require 'tetrahedron/application/controller'
        require 'tetrahedron/application/endpoint'

  require 'tetrahedron/service'
    require 'tetrahedron/database'
      require 'tetrahedron/databases/sqlite3'
      require 'tetrahedron/databases/postgres'

  # require 'tetrahedron/cache'
  #   require 'tetrahedron/caches/null'     #=> ActiveSupport::Cache::NullStore
  #   require 'tetrahedron/caches/memory'   #=> ActiveSupport::Cache::MemoryStore
  #   require 'tetrahedron/caches/memcache' #=> Dalli
  #   require 'tetrahedron/caches/redis'    #=> Hiredis
  # require 'tetrahedron/queue'
  #   require 'tetrahedron/queues/null'     #=> .*~~~ The Abyss ~~~*.
  #   require 'tetrahedron/queues/spawn'    #=> Thread.new
  #   require 'tetrahedron/queues/sidekiq'  #=> Sidekiq (from Redis, with Love)
end
