namespace :tet do
  task :up do
    exec "puma -C #{File.join(Tetrahedron.root, 'config', 'puma.rb')}"
  end
end
