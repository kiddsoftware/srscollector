require 'spec_helper'

describe Card do
  subject(:card) { FactoryGirl.build(:card) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }

  it { should belong_to(:card_model) }
  # This field is filled in automatically, so we can't test the validation.
  # Not to worry; it's tested by lots of other code.
  #it { should validate_presence_of(:card_model) }

  it { should have_many(:media_files) }

  it { should validate_presence_of(:front) }
  it { should allow_value("text").for(:front) }

  it { should_not validate_presence_of(:back) }
  it { should allow_value("definitions").for(:back) }

  it { should_not validate_presence_of(:source) }
  it { should_not validate_presence_of(:source_url) }

  it { should validate_presence_of(:state) }
  %w(new reviewed exported set_aside).each do |s|
    it { should allow_value(s).for(:state) }
  end
  it { should_not allow_value("foo").for(:state) }
  it ".state should initially be new" do
    card.state.should == "new"
  end

  describe "HTML transformation" do
    it "removes empty spans" do
      card.front = "my text <span>is <i>very</i> interesting</span>"
      card.front.should == "my text is <i>very</i> interesting"
      card.back =
        "my text <span><script></script>is <i>also</i> interesting</span>"
      card.back.should == "my text is <i>also</i> interesting"
    end

    it "makes local copies of images when possible" do
      image_url = stub_image_url

      # Make sure we cache each external image once.
      card.front = "<img src='#{image_url}'>"
      card.back = "<img src='#{image_url}'><img src='#{image_url}'>"
      card.media_files.length.should == 1
      card.media_files[0].url.should == image_url

      # Make sure we can save recursively, too.
      card.save!
      card.media_files[0].should_not be_new_record

      # Make sure we fix URLs for export.
      rel_url = card.media_files[0].export_filename
      card.front_for_anki.should == "<img src=\"#{rel_url}\">"
      card.back_for_anki.should ==
        "<img src=\"#{rel_url}\"><img src=\"#{rel_url}\">"
    end

    it "ignores images which don't exist" do
      image_url = "http://www.example.com/image.png"
      stub_request(:get, image_url).to_return(status: 404)

      # Make sure we cache each external image once.
      card.back = "<img src='#{image_url}'>"
      card.media_files.length.should == 0
      card.back_for_anki.should == "<img src=\"#{image_url}\">"
    end
  end

  describe "#source_html" do
    it "should be the source name linking to the source_url" do
      card = FactoryGirl.build(:card, source: "a",
                               source_url: "http://example.com")
      card.source_html.should == '<a href="http://example.com">a</a>'
    end

    it "should be nil if source and source_url are nil" do
      card = FactoryGirl.build(:card, source: nil, source_url: nil)
      card.source_html.should be_nil
    end

    it "should be the source if we only have that" do
      card = FactoryGirl.build(:card, source: "Testing & Stuff", source_url: nil)
      card.source_html.should == "Testing &amp; Stuff"
    end

    it "should be the source_url as a link if we only have that" do
      card = FactoryGirl.build(:card, source: nil,
                               source_url: "http://example.com")
      card.source_html.should ==
        '<a href="http://example.com">http://example.com</a>'
    end
  end

  describe ".to_csv" do
    it "should convert a list of cards to CSV format" do
      cards = [FactoryGirl.build(:card, front: "Example")]
      csv = Card.to_csv(cards)
      csv.should match(/Example/)
    end
  end

  describe ".to_media_zip" do
    it "converts a list of cards into a zip file of the associated media" do
      image_url = stub_image_url
      cards = [FactoryGirl.create(:card, front: "<img src='#{image_url}'>")]
      zip = Card.to_media_zip(cards)
      Zip::Archive.open_buffer(zip) do |ar|
        ar.num_files.should == 2
        ar.each {|f| f.size.should > 0 }
      end
    end
  end

  describe "Test infrastructure" do
    it "uses 'basic' model for cards by default" do
      card1 = FactoryGirl.create(:card)
      card2 = FactoryGirl.create(:card)
      card1.card_model.short_name.should == "basic"
      card1.card_model.should == card2.card_model
    end
  end
end
