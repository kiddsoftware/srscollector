# -*- coding: utf-8 -*-
require 'spec_helper'
require 'encoding_detector'

describe EncodingDetector do
  def text
    "Pour que le caractère d'un être humain dévoile des qualités vraiment exceptionnelles, il faut avoir la bonne fortune de pouvoir observer son action pendant de longues années."
  end

  describe ".detect" do
    it "detects UTF-8 (default encoding)" do
      misencoded = text.encode("utf-8").force_encoding("binary")
      EncodingDetector.detect(misencoded).should == "UTF-8"
    end
    
    it "detects UTF-16LE with Byte Order Mark (Unicode on Windows)" do
      misencoded = ("\uFEFF"+text).encode("utf-16le").force_encoding("binary")
      EncodingDetector.detect(misencoded).should == "UTF-16LE"
    end

    it "detects ISO-8859-1" do
      misencoded = text.encode("iso-8859-1").force_encoding("binary")
      EncodingDetector.detect(misencoded).should == "ISO-8859-1"
    end

    it "detects the encoding of a file" do      
      path = File.join(Rails.root, 'spec', 'fixtures', 'files', 'subtitles.srt')
      data = File.read(path)
      EncodingDetector.detect(data).should == "ISO-8859-1"
    end
  end

  describe ".ensure_utf8" do
    it "converts everything to UTF-8" do
      misencoded = text.encode("iso-8859-1").force_encoding("binary")
      utf8 = EncodingDetector.ensure_utf8(misencoded)
      utf8.encoding.should == Encoding::UTF_8
      utf8.should == text
    end
  end
end
