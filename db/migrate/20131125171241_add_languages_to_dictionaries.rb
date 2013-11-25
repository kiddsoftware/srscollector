class AddLanguagesToDictionaries < ActiveRecord::Migration
  def change
    # Don't bother to migrate the data; let seeds.rb sort it out.
    add_reference :dictionaries, :to_language, index: true
    add_reference :dictionaries, :from_language, index: true
    remove_column :dictionaries, :to_lang
    remove_column :dictionaries, :from_lang
  end
end
