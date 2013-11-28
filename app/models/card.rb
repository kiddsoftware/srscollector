require 'csv'
require 'rack/utils'

class Card < ActiveRecord::Base
  STATES = %w(new reviewed exported set_aside)

  belongs_to :user
  belongs_to :card_model
  belongs_to :language

  # See the inverse relationship for an explanation of `inverse_of` here.
  has_many :media_files, inverse_of: :card

  validates :user, presence: true
  validates :card_model, presence: true
  validates :language, presence: true, if: Proc.new {|c| c.state == 'reviewed' }
  validates :front, presence: true
  validates :state, presence: true, inclusion: STATES

  # Detect cloze cards and change our type accordingly.
  def front=(html)
    short_name = if html =~ /\{\{c/ then "cloze" else "basic" end
    self.card_model = CardModel.where(short_name: short_name).first!
    write_attribute(:front, html)
  end

  # Clean up our HTML a bit before saving it.  We need to wait until we
  # have an associated user.
  before_validation do
    write_attribute(:front, sanitize_html(front)) if front_changed?
    write_attribute(:back, sanitize_html(back)) if back_changed?
  end

  # Transform HTML again when we export to Anki.
  def front_for_anki() html_for_anki(front) end
  def back_for_anki() html_for_anki(back) end

  # Format source and source_url for output to Anki.
  def source_html
    case
    when source.blank? && source_url.blank?
      nil
    when source_url.blank?
      ERB::Util.h(source)
    when source.blank?
      url = ERB::Util.h(source_url)
      "<a href=\"#{url}\">#{url}</a>"
    else
      "<a href=\"#{ERB::Util.h(source_url)}\">#{ERB::Util.h(source)}</a>"
    end
  end

  # Generate a CSV file suitable for import into Anki.
  def self.to_csv(cards)
    CSV.generate do |csv|
      cards.each do |card|
        csv << [card.front_for_anki, card.back_for_anki, card.source_html]
      end
    end
  end

  # Generate a zip file containing all the media needed for the specified
  # cards.
  # TODO: Fragile as can be.  Will eventually go away.
  def self.to_media_zip(cards)
    seen = {}
    Zip::Archive.open_buffer(Zip::CREATE) do |ar|
      ar.add_buffer("MEDIA-README.txt",
                    "Merge this with your collection.media directory.")
      cards.each do |card|
        card.media_files.each do |mf|
          filename = mf.export_filename
          next if seen[filename]
          seen[filename] = true
          mf.open_local do |f|
            ar.add_buffer("collection.media/#{filename}", f.read)
          end
        end
      end
    end  
  end

  # Mix this module into associations containing cards.
  module AssociationMethods
    # Create new cards from Kindle-format clippings data.
    def create_from_clippings(clippings)
      clippings.split(/==========\r?\n/).each do |clipping|
        title, info, blank, body = clipping.split(/\r?\n/)
        next unless info =~ /^- Highlight/
        create(front: Rack::Utils.escape_html(body), source: title)
      end
    end
  end

  private
  
  # Clean up useless <span></span> objects left everywhere by wysihtml5.
  class RemoveEmptySpans
    def call(env)
      node = env[:node]
      return if env[:is_whitelisted]
      return unless node.element? && env[:node_name] == 'span'
      return unless node.attribute_nodes.empty?

      # Hoist our children up and remove us.
      node.children.each {|n| node.add_previous_sibling(n) }
      node.unlink
      return
    end
  end

  class ImageTransformer
    attr_reader :card

    def initialize(card)
      @card = card
    end

    def image_node?(env)
      return false if env[:is_whitelisted]
      return false unless env[:node].element? && env[:node_name] == 'img'
      return false unless src = env[:node].attr("src")
      true
    end
  end

  # Make local copies of files pointed to by <img> tags.
  class CacheImages < ImageTransformer
    def call(env)
      return unless image_node?(env)
      src = env[:node].attr("src")
      return if card.media_files.any? {|mf| mf.url == src }

      # Cache a new image if possible.
      mf = card.media_files.build(url: src)
      card.media_files.destroy(mf) unless mf.valid?
      return
    end
  end

  # Replace image links with the filenames we want Anki to use.
  class RewriteImageSources < ImageTransformer
    def call(env)
      return unless image_node?(env)
      src = env[:node].attr("src")
      mf = card.media_files.find {|mf| mf.url == src }
      return unless mf
      env[:node].set_attribute("src", mf.export_filename)
      { node_whitelist: [env[:node]] }
    end
  end

  # Start out with a relatively restricted sanitize config, and add some
  # useful bits to it.
  SANITIZE_CONFIG = Sanitize::Config::BASIC.deep_dup
  SANITIZE_CONFIG[:elements] += %w(img div span)
  SANITIZE_CONFIG[:attributes][:all] = %w(class)
  SANITIZE_CONFIG[:attributes]['img'] = %w(align alt height src width)
  SANITIZE_CONFIG[:protocols]['img'] = { 'src' => ['http', 'https'] }

  # Aggressively clean up our HTML.
  def sanitize_html(html)
    if user.supporter?
      transformers = [RemoveEmptySpans.new, CacheImages.new(self)]
    else
      transformers = [RemoveEmptySpans.new]
    end
    Sanitize.clean(html, SANITIZE_CONFIG.merge(transformers: transformers))
  end

  # Tweak our <img> tags for export to Anki.
  def html_for_anki(html)
    transformers = [RewriteImageSources.new(self)]
    Sanitize.clean(html, SANITIZE_CONFIG.merge(transformers: transformers))
  end
end
