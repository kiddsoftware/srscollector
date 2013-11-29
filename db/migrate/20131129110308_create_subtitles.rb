class CreateSubtitles < ActiveRecord::Migration
  def change
    create_table :subtitles do |t|
      t.references :playable_media, index: true, null: false
      t.references :language, index: true, null: false
      t.float :start_time, null: false
      t.float :end_time, null: false
      t.text :text

      t.timestamps
    end
    add_index :subtitles, [:playable_media_id, :language_id]
    add_index :subtitles, [:playable_media_id, :start_time]
    add_index :subtitles, [:playable_media_id, :end_time]
  end
end
