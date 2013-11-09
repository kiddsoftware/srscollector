namespace :anki do
  desc "Install Anki plugin"

  task install: :environment do
    anki_dir = File.expand_path("./Anki/addons", Dir.home) + "/"
    files = ["extras/anki/SRS_Collector.py", "extras/anki/srscollector"]
    cp_r files, anki_dir, verbose: true
  end
end
