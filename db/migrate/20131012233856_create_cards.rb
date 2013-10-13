class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :state
      t.text :front
      t.text :back
      t.text :source
      t.text :source_url

      t.timestamps
    end
  end
end
