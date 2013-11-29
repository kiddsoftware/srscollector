# -*- coding: utf-8 -*-
require 'spec_helper'
require 'encoding_detector'

describe EncodingDetector do
  describe "detect" do
    it "detects UTF-8" do
      misencoded = "là où".encode("utf-8").force_encoding("iso-8859-1")
      EncodingDetector.detect(misencoded).should == "utf-8"
    end
    
    it "detects UTF-16LE" do
      misencoded = "là où".encode("utf-16le").force_encoding("utf-8")
      EncodingDetector.detect(misencoded).should == "utf-16le"
    end

    it "detects ISO-8859-1" do
      misencoded = "là où".encode("iso-8859-1").force_encoding("utf-8")
      EncodingDetector.detect(misencoded).should == "iso-8859-1"
    end
  end

  describe "ensure_utf8" do
    it "converts everything to UTF-8" do
      misencoded = "là où".encode("iso-8859-1").force_encoding("utf-8")
      utf8 = EncodingDetector.ensure_utf8(misencoded)
      utf8.encoding.should == Encoding::UTF_8
      utf8.should == "là où"
    end
  end
end
