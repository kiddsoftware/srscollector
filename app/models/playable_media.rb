require 'encoding_detector'

class PlayableMedia < ActiveRecord::Base
  belongs_to :user
  belongs_to :language
  has_many :subtitles, dependent: :delete_all

  validates :user, presence: true
  validates :language, presence: true
  validates :kind, presence: true, inclusion: { in: ['audio', 'video'] }
  validates :url, presence: true
  validates :title, presence: true

  attr_writer :subtitles_urls

  after_initialize do
    # Don't run after loading existing records, etc.
    return unless new_record?
      
    # Default our kind if necessary.
    if url && !kind
      ext = File.extname(url).sub(/\A\./, '').downcase
      mime = Mime::Type.lookup_by_extension(ext)
      if mime
        mime.to_s =~ /\A(audio|video)\//
        self.kind = $1
      end
    end

    # Import our subtitles.
    if @subtitles_urls
      for url in @subtitles_urls
        data = HTTParty.get(url).body
        add_srt_data(EncodingDetector.ensure_utf8(data))
        self.language ||= subtitles.first.language
      end
      puts subtitles.last.errors.inspect unless subtitles.last.valid?
    end
  end

  # Parse an SRT-format subtitle file and add the records to this class.
  def add_srt_data(text)
    language = Language.detect(text)
    text.gsub(/\r\n/, "\n").split(/\n\n/).each do |block|
      index, times, text = block.split(/\n/, 3)
      start_time, end_time = parse_srt_times(times)
      # TODO: Is this the best way to add records to an unsaved has_many?
      self.subtitles <<
        Subtitle.new(playable_media: self, language: language,
                     start_time: start_time, end_time: end_time,
                     text: text.chomp)
    end
  end

  private

  # Parse an SRT time range.
  def parse_srt_times(times)
    times =~ /^([0-9:,]+) --> ([0-9:,]+)/ # May have trailing data.
    [$1, $2].map {|t| parse_srt_time(t) }
  end

  # Parse an SRT time.  We don't try to do support WebVTT (yet).
  def parse_srt_time(time)
    time =~ /^(\d+):(\d+):(\d+),(\d{3})$/
    hh, mm, ss, ms = [$1, $2, $3, $4].map(&:to_i)
    hh*3600 + mm*60 + ss + ms/1000.0
  end
end
