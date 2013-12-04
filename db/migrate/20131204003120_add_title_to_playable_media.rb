class AddTitleToPlayableMedia < ActiveRecord::Migration
  def change
    add_column :playable_media, :title, :string
  end
end
