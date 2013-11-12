
namespace :anki do
  desc "Install Anki plugin"

  task :install do
    anki_dir = File.expand_path("./Anki/addons", Dir.home) + "/"
    files = "extras/anki/SRS_Collector.py", "extras/anki/srscollector"
    cp_r files, anki_dir, verbose: true
  end

  task :package do
    cd "extras/anki" do
      sh "zip", "-r", "srscollector_anki_addon.zip", *Dir["**/*.py"]
    end
  end
end
