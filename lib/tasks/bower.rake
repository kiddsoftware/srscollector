namespace :bower do
  # Patch up a few assets that don't get built correctly otherwise.
  task :install_assets do
    mkdir_p "public/fonts"
    Dir["vendor/assets/components/bootstrap/fonts/glyphicons-*"].each do |font|
      cp font, "public/fonts"
    end
  end
end

namespace :assets do
  task :precompile => "bower:install_assets"
end
