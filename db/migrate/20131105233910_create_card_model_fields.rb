class CreateCardModelFields < ActiveRecord::Migration
  def change
    create_table :card_model_fields do |t|
      t.references :card_model, index: true, null: false
      t.integer :order, null: false
      t.string :name, null: false
      t.string :card_attr, null: false

      t.timestamps
    end
  end
end
