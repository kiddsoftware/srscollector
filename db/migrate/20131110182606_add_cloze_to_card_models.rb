class AddClozeToCardModels < ActiveRecord::Migration
  def change
    add_column :card_models, :cloze, :boolean, default: false
  end
end
