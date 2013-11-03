class MediaFile < ActiveRecord::Base
  # Declare the inverse_of here so we can validate the presence of `card`
  # while all our records are unsaved.
  belongs_to :card, inverse_of: :media_files
  has_attached_file :file, styles: { original: "240x240>" }

  validates :card, presence: true
  validates_attachment :file,
    presence: true,
    content_type: { content_type: /^image\/(jpg|png|gif)$/ },
    size: { in: 0..128.kilobytes }
  validates :file_fingerprint, presence: true

  # Generate a reasonably unique filename for exporting this file.
  def export_filename
    ext = File.extname(url)
    "srsc-#{file_fingerprint}#{ext}".downcase
  end

  # Download our URL.
  before_validation(on: :create) do
    begin
      if url && url =~ /\Ahttps?:/ && !file.exists?
        open(URI.parse(url)) do |f|
          self.file = f
        end
      end
    rescue => e
      logger.error("Cannot download #{url}: #{e.message}")
    end
  end
end
