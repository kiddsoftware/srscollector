class ExportCardSerializer < CardSerializer
  # Combined version of source and source_url.
  attributes :source_html

  # Include our media file information when exporting.
  has_many :media_files

  # Sideload our card models.
  has_one :card_model, embed: :ids, include: true

  # Override these attributes to use the modified version of our HTML.
  def front() object.front_for_anki end
  def back() object.back_for_anki end
end
