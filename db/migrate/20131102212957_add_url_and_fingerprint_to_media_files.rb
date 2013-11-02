class AddUrlAndFingerprintToMediaFiles < ActiveRecord::Migration
  def change
    add_column :media_files, :url, :string
    add_column :media_files, :file_fingerprint, :string
  end
end
