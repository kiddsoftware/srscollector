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
}, {
  name: "Bing Image Search",
  from_lang: 'fr',
  to_lang: '*',
  url_pattern: 'http://www.bing.com/images/search?q=%s+language%3Afr',
  score: 0.80

# DO NOT WORK:
#  Google Translate: X-SAME-ORIGIN (but a paid API is available)
#  Google Images: X-SAME-ORIGIN (tried custom search engines, looks tricky)
}]

def create_or_update_dictionary(attrs)
  d = Dictionary.where(attrs.slice(:name, :from_lang, :to_lang)).first_or_create
  d.update_attributes(attrs)
end

dictionaries.each {|dict| create_or_update_dictionary(dict) }

# Create our basic card model.
basic = CardModel.where(short_name: "basic").first_or_initialize
css = <<EOD
.card {
 font-family: arial;
 font-size: 20px;
 text-align: center;
 color: black;
 background-color: white;
}

.source {
  margin-top: 20px;
  font-size: 14px;
  font-style: italic;
  color: grey;
}
EOD
basic.update_attributes({
  name: "SRS Collector Basic",
  anki_css: css
})

# Create our card template.
template = CardModelTemplate.where(card_model: basic, name: "Card 1")
  .first_or_initialize
front = <<EOD
<div class="front">{{Front}}</div>
{{#Source}}
<div class="source">{{Source}}</div>
{{/Source}}
EOD
back = <<EOD
{{FrontSide}}
<hr id="answer">
<div class="back">{{Back}}</div>
EOD
template.update_attributes({
  order: 0,
  anki_front_template: front,
  anki_back_template: back
})

# XXX - This is really more of a migration, but we put it here to avoid having
# to carefully interleve the order of migrations and seeds.
Card.where(card_model_id: nil).update_all(card_model_id: basic.id)

# Add a cloze model, too.
cloze = CardModel.where(short_name: "cloze").first_or_initialize
cloze_css = <<"EOD"
#{css}
.cloze {
  font-weight: bold;
  color: blue;
}
EOD
cloze.update_attributes({
  name: "SRS Collector Cloze",
  anki_css: cloze_css,
  cloze: true
})

# Create our card template.
cloze_template = CardModelTemplate.where(card_model: cloze, name: "Cloze")
  .first_or_initialize
cloze_front = <<EOD
<div class="front">{{cloze:Front}}</div>
{{#Source}}
<div class="source">{{Source}}</div>
{{/Source}}
EOD
cloze_back = <<EOD
{{FrontSide}}
{{#Back}}
<hr id="answer">
<div class="back">{{Back}}</div>
{{/Back}}
EOD
cloze_template.update_attributes({
  order: 0,
  anki_front_template: cloze_front,
  anki_back_template: cloze_back
})

# Make sure we have our standard fields, too.
[{
  order: 0,
  name: "Front",
  card_attr: "front"
}, {
  order: 1,
  name: "Back",
  card_attr: "back"
}, {
  order: 2,
  name: "Source",
  card_attr: "source_html"
}].each do |field|
  [basic, cloze].each do |model|
    f = model.card_model_fields.where(name: field[:name]).first_or_initialize
    f.update_attributes(field)
    f.save!
  end
end
