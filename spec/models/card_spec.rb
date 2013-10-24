require 'spec_helper'

describe Card do
  subject(:card) { FactoryGirl.build(:card) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }

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
end
