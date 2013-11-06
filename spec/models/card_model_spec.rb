require 'spec_helper'

describe CardModel do
  subject { FactoryGirl.create(:card_model) }

  it { should have_many(:cards) }
  it { should have_many(:card_model_fields) }

  it { should validate_presence_of(:short_name) }
  it { should validate_uniqueness_of(:short_name) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it { should validate_presence_of(:anki_front_template) }
  it { should validate_presence_of(:anki_back_template) }
  it { should validate_presence_of(:anki_css) }
end
