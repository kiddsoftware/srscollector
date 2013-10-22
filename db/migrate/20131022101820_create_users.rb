class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false

      t.timestamps
    end
    add_column :cards, :user_id, :integer
    # This index allows us to list all a user's cards in a sensible order,
    # and to pick off the next card in need of attention.  It it presumably
    # expensive to update, however.
    add_index :cards, [:user_id, :state, :created_at, :id]
  end
end
