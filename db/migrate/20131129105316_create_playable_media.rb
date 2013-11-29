class CreatePlayableMedia < ActiveRecord::Migration
  def change
    create_table :playable_media do |t|
      t.references :user, index: true, null: false
      t.references :language, index: true, null: false
      t.string :type, null: false
      t.text :url

      t.timestamps
    end
  end
end
