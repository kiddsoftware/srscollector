class RenamePlayableMediaTypeToKind < ActiveRecord::Migration
  def change
    rename_column :playable_media, :type, :kind
  end
end
