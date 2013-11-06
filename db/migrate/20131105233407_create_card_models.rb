
class CreateCardModels < ActiveRecord::Migration
  def change
    create_table :card_models do |t|
      t.string :short_name, unique: true, null: false
      t.string :name, unique: true, null: false
      t.text :anki_front_template, null: false
      t.text :anki_back_template, null: false
      t.text :anki_css, null: false

      t.timestamps
    end
    add_reference :cards, :card_model, index: true
  end
end
