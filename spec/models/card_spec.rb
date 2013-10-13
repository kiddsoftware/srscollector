require 'spec_helper'

describe Card do
  subject(:card) { FactoryGirl.build(:card) }

  it { should validate_presence_of(:front) }
  it { should allow_value("text").for(:front) }

  it { should_not validate_presence_of(:back) }
  it { should allow_value("definitions").for(:back) }

  it { should_not validate_presence_of(:source) }
  it { should_not validate_presence_of(:source_url) }

  describe ".state" do
    it "should initially be new" do
      card.should be_new
    end
  end
end
