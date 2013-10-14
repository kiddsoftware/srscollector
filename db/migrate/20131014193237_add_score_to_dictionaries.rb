class AddScoreToDictionaries < ActiveRecord::Migration
  def change
    add_column :dictionaries, :score, :float, null: false, default: 0
  end
end
