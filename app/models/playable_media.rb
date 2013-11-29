class PlayableMedia < ActiveRecord::Base
  belongs_to :user
  belongs_to :language
  has_many :subtitles

  validates :user, presence: true
  validates :language, presence: true
  validates :type, presence: true, inclusion: { in: ['audio', 'video'] }
  validates :url, presence: true

  def add_srt_data(text)
    language = Language.detect(text)
    text.gsub(/\r\n/, "\n").split(/\n\n/).each do |block|
      index, times, text = block.split(/\n/, 3)
      start_time, end_time = parse_srt_times(times)
      subtitles.build(language: language, start_time: start_time,
                      end_time: end_time, text: text.chomp)
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
