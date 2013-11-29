module EncodingDetector
  # Do our best to detect the encoding of `text`, giving priority to people
  # sensible enough to use UTF-8 (or UTF-16LE) in the first place.
  def self.detect(text)
    # Two easily-identifiable, high-priority encodings that we definitely
    # want to use whenever they are valid.
    %w(utf-8 utf-16le).each do |encoding|
      text.force_encoding(encoding)
      return encoding if text.valid_encoding?
    end

    # The user has given us a non-Unicode encoding, or an uncommon Unicode
    # encoding, so guess the best we can.  We outsource this to the GNU
    # file command, which seems adequate so far.
    text.force_encoding("binary")
    file = Tempfile.new("srs-collector-encoding", encoding: "binary")
    begin
      file.write(text)
      file.close
      IO.popen("file -b --mime-encoding '#{file.path}'") do |io|
        return io.read.chomp
      end
    ensure
      file.close
      file.unlink
    end
  end

  # Make sure a string is in valid UTF-8 format.
  def self.ensure_utf8(text)
    text.force_encoding(detect(text)).encode("utf-8")
  end
end
