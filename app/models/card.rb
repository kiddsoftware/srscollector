require 'csv'

class Card < ActiveRecord::Base
  STATES = %w(new reviewed exported set_aside)

  belongs_to :user
  has_many :media_files

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

  # Start out with a relatively restricted sanitize config, and add some
  # useful bits to it.
  SANITIZE_CONFIG = Sanitize::Config::BASIC.deep_dup
  SANITIZE_CONFIG[:elements] += %w(img div span)
  SANITIZE_CONFIG[:attributes][:all] = %w(class)
  SANITIZE_CONFIG[:attributes]['img'] = %w(align alt height src width)
  SANITIZE_CONFIG[:protocols]['img'] = { 'src' => ['http', 'https'] }
  SANITIZE_CONFIG[:transformers] = [RemoveEmptySpans.new]

  # Aggressively clean up our HTML.
  def sanitize_html(html)
    Sanitize.clean(html, SANITIZE_CONFIG)
  end
end
