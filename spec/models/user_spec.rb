require 'spec_helper'

describe User do
  subject { FactoryGirl.create(:user) }

  it { should have_many(:cards) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_secure_password }
end
