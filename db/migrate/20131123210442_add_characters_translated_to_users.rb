class AddCharactersTranslatedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :characters_translated, :integer, default: 0
  end
end
