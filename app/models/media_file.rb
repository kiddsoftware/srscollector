class MediaFile < ActiveRecord::Base
  # Declare the inverse_of here so we can validate the presence of `card`
  # while all our records are unsaved.
  belongs_to :card, inverse_of: :media_files
  has_attached_file :file, styles: { original: ["240x240>", :jpg] }

  validates :card, presence: true
  validates_attachment :file,
    presence: true,
    size: { in: 0..128.kilobytes }
  validates :file_fingerprint, presence: true

  # Generate a reasonably unique filename for exporting this file.
  def export_filename
    "srsc-#{file_fingerprint}.jpg"
  end

  # Copy everything to a local tempfile, open it, call a block, and clean up.
  def open_local # :yields: io
    temp = Tempfile.new('media_file')
    begin
      file.copy_to_local_file(:original, temp.path)
      open(temp.path) {|f| yield f }
    ensure
      temp.close
    end
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
