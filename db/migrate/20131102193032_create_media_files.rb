class CreateMediaFiles < ActiveRecord::Migration
  def change
    create_table :media_files do |t|
      t.references :card, null: false, index: true
      t.timestamps
    end
    reversible do |dir|
      dir.up { add_attachment :media_files, :file }
      dir.down { remove_attachment :media_files, :file }
    end
  end
end
