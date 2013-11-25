class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :iso_639_1, null: false, unique: true
      t.string :name, null: false, unique: true
      t.string :anki_text_deck, null: false
      t.string :anki_sound_deck, null: false

      t.timestamps
    end

    add_index :languages, :iso_639_1, unique: true
    add_index :languages, :name, unique: true
  end
end
