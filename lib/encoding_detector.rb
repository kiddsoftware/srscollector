require "charlock_holmes"

module EncodingDetector
  # Do our best to detect the encoding of `text`, giving priority to people
  # sensible enough to use UTF-8 in the first place..
  def self.detect(text)
    text = text.dup

    # If it's valid UTF-8, assume it's UTF-8.  This is both the sensible
    # default and the one format always guaranteed to work.
    text.force_encoding("UTF-8")
    return "UTF-8" if text.valid_encoding?

    # Let rchardet handle this for us.
    text.force_encoding("binary")
    detected = CharlockHolmes::EncodingDetector.detect(text)
    if detected
      detected[:encoding]
    else
      nil
    end
  end

  # Make sure a string is in valid UTF-8 format.
  def self.ensure_utf8(text)
    text.force_encoding(detect(text)).encode("UTF-8")
  end
end
