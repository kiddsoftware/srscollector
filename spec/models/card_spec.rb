# -*- coding: utf-8 -*-
require 'spec_helper'

describe Card do
  subject(:card) { FactoryGirl.build(:card) }

  it { should belong_to(:user) }
  # We can't test validation of this field because HTML sanitization before
  # validation will crash if it is not available.
  #it { should validate_presence_of(:user) }

  it { should belong_to(:card_model) }
  # This field is filled in automatically, so we can't test the validation.
  # Not to worry; it's tested by lots of other code.
  #it { should validate_presence_of(:card_model) }

  it { should belong_to(:language) }
  it { should_not validate_presence_of(:language) }

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

  describe "card_model" do
    before do
      default_card_model_for_spec
      default_cloze_card_model_for_spec
    end

    it "defaults to 'basic'" do
      card.card_model.short_name.should == 'basic'
    end

    it "switches to 'cloze' if cloze-text appears on the card" do
      card.front = "a{{c1::b}}c"
      card.card_model.short_name.should == 'cloze'
    end
  end

  describe "HTML transformation" do
    it "removes empty spans" do
      card.front = "my text <span>is <i>very</i> interesting</span>"
      card.back =
        "my text <span><script></script>is <i>also</i> interesting</span>"
      card.valid?
      card.front.should == "my text is <i>very</i> interesting"
      card.back.should == "my text is <i>also</i> interesting"
    end

    it "makes local copies of images when possible for supporters" do
      image_url = stub_image_url
      card.user.supporter = true
      card.user.save!

      # Make sure we cache each external image once.
      card.front = "<img src='#{image_url}'>"
      card.back = "<img src='#{image_url}'><img src='#{image_url}'>"
      card.valid?
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

    it "ignores images for non-supporters" do
      image_url = stub_image_url
      card.front = "<img src='#{image_url}'>"
      card.media_files.length.should == 0
      card.front_for_anki.should == "<img src=\"#{image_url}\">"
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
      user = FactoryGirl.create(:user, supporter: true)
      cards = [FactoryGirl.create(:card, user: user,
                                  front: "<img src='#{image_url}'>")]
      zip = Card.to_media_zip(cards)
      Zip::Archive.open_buffer(zip) do |ar|
        ar.num_files.should == 2
        ar.each {|f| f.size.should > 0 }
      end
    end
  end

  describe ".create_from_clippings" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      default_card_model_for_spec
      clippings = <<"EOD"
Les Fleurs du mal (Charles Baudelaire)
- Bookmark on Page 30 | Loc. 459  | Added on Tuesday, March 26, 2013, 07:06 AM


==========
Les Fleurs du mal (Charles Baudelaire)
- Highlight on Page 33 | Loc. 497  | Added on Tuesday, March 26, 2013, 07:08 AM

Tant l'écheveau du temps lentement se dévide !
==========
Les Fleurs du mal (Charles Baudelaire)
- Highlight on Page 36 | Loc. 540-41  | Added on Tuesday, March 26, 2013, 07:14 AM

Deux guerriers ont couru l'un sur l'autre, leurs armes Ont éclaboussé l'air de lueurs et de sang.
==========
Les Fleurs du mal (Charles Baudelaire)
- Highlight on Page 36 | Loc. 541-42  | Added on Tuesday, March 26, 2013, 07:14 AM

Ces jeux, ces cliquetis du fer sont les vacarmes D'une jeunesse en proie à l'amour vagissant.
==========
EOD
      user.cards.create_from_clippings(clippings)
    end

    it "only imports highlights" do
      user.cards.length.should == 3
    end

    it "sets source appropriately" do
      user.cards.first.source.should == "Les Fleurs du mal (Charles Baudelaire)"
    end

    it "imports highlight text" do
      user.cards.first.front.should match(/du temps/)
    end
  end

  describe "Test infrastructure" do
    it "uses 'basic' model for cards by default" do
      card1 = FactoryGirl.create(:card)
      card2 = FactoryGirl.create(:card)
      card1.card_model.short_name.should == "basic"
      card1.card_model.should == card2.card_model
      card1.card_model.card_model_fields.length.should == 3
    end
  end
end
