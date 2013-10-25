class AddAPIKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :api_key, :string
    add_index :users, :api_key, unique: true # (Multiple NULLs allowed.)
  end
end
