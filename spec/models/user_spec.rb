require 'spec_helper'

describe User do
  subject(:user) { FactoryGirl.create(:user) }

  it { should have_many(:cards) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_secure_password }
  it { should_not validate_presence_of(:api_key) }

  describe "#ensure_api_key!" do
    it "generates an api_key if none is present and saves the user" do
      user.api_key.should be_nil
      user.ensure_api_key!
      user.should_not be_changed # It should already be saved.
      key = user.api_key
      key.should_not be_nil
      user.ensure_api_key!
      user.api_key.should == key
    end
  end
end
