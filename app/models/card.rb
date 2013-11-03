require 'csv'

class Card < ActiveRecord::Base
  STATES = %w(new reviewed exported set_aside)

  belongs_to :user

  # See the inverse relationship for an explanation of `inverse_of` here.
  has_many :media_files, inverse_of: :card

  validates :user, presence: true
  validates :front, presence: true
  validates :state, presence: true, inclusion: STATES

  # Clean up our HTML a bit before saving it.
  def front=(html) write_attribute(:front, sanitize_html(html)) end
  def back=(html) write_attribute(:back, sanitize_html(html)) end

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

  def self.to_csv(cards)
    CSV.generate do |csv|
      cards.each do |card|
        csv << [card.front, card.back, card.source_html]
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

  # Make local copies of files pointed to by <img> tags.
  class CacheImages
    attr_reader :card

    def initialize(card)
      @card = card
    end

    def call(env)
      node = env[:node]
      return if env[:is_whitelisted]
      return unless node.element? && env[:node_name] == 'img'
      
      # Return if we don't have a src, or if we've already cached it.
      src = node.attr("src")
      return unless src
      return if card.media_files.any? {|mf| mf.url == src }

      # Cache a new image if possible.
      mf = card.media_files.build(url: src)
      card.media_files.destroy(mf) unless mf.valid?
      return
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
    transformers = [RemoveEmptySpans.new, CacheImages.new(self)]
    Sanitize.clean(html, SANITIZE_CONFIG.merge(transformers: transformers))
  end
end
