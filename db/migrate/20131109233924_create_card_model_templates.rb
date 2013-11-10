class CreateCardModelTemplates < ActiveRecord::Migration
  def change
    create_table :card_model_templates do |t|
      t.references :card_model, index: true, null: false
      t.integer :order, null: false
      t.string :name, null: false
      t.text :anki_front_template, null: false
      t.text :anki_back_template, null: false

      t.timestamps
    end

    remove_column :card_models, :anki_front_template, :text
    remove_column :card_models, :anki_back_template, :text
  end
end
