class CreateDictionaries < ActiveRecord::Migration
  def change
    create_table :dictionaries do |t|
      t.string :name, null: false
      t.string :from_lang, null: false
      t.string :to_lang, null: false
      t.string :url_pattern, null: false

      t.timestamps
    end
  end
end
