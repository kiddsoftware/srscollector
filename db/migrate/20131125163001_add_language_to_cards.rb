class AddLanguageToCards < ActiveRecord::Migration
  def change
    add_reference :cards, :language, index: true
  end
end
