class DefaultCardStateToNew < ActiveRecord::Migration
  def up
    change_column :cards, :state, :string, :default => "new"
  end
end
