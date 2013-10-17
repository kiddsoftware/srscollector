# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

dictionaries = [{
  name: "Wiktionnaire",
  from_lang: 'fr',
  to_lang: 'fr',
  url_pattern: 'http://fr.wiktionary.org/wiki/%s',
  score: 1.0
}, {
  name: "Linguee",
  from_lang: 'fr',
  to_lang: 'en',
  url_pattern: "http://www.linguee.fr/francais-anglais/search?source=auto&query=%s",
  score: 0.91
}, {
  name: "WordReference",
  from_lang: 'fr',
  to_lang: 'en',
  url_pattern: 'http://www.wordreference.com/fren/%s',
  score: 0.90

# DO NOT WORK:
#  Google Translate: X-SAME-ORIGIN (but a paid API is available)
#  Google Images: X-SAME-ORIGIN (tried custom search engines, looks tricky)
}]

def create_or_update_dictionary(attrs)
  d = Dictionary.where(attrs.slice(:name, :from_lang, :to_lang)).first_or_create
  d.update_attributes(attrs)
end

dictionaries.each {|dict| create_or_update_dictionary(dict) }
