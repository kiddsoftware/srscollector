class AddAuthTokenAndPasswordResetTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_sent_at, :datetime

    # These columns may contain multiple NULLs, but values must be unique.
    add_index :users, :auth_token, unique: true
    add_index :users, :password_reset_token, unique: true
  end
end
