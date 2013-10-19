require 'spec_helper'

describe Card do
  subject(:card) { FactoryGirl.build(:card) }

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

  describe ".to_csv" do
    it "should convert a list of cards to CSV format" do
      cards = [FactoryGirl.build(:card, front: "Example")]
      csv = Card.to_csv(cards)
      csv.should match(/Example/)
    end
  end
end
