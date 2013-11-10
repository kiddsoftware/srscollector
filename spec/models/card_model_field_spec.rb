require 'spec_helper'

describe CardModelField do
  subject { FactoryGirl.create(:card_model_field) }

  it { should belong_to(:card_model) }
  it { should validate_presence_of(:card_model) }

  it { should validate_uniqueness_of(:order).scoped_to(:card_model_id) }
  it { should validate_uniqueness_of(:name).scoped_to(:card_model_id) }
  it { should validate_uniqueness_of(:card_attr).scoped_to(:card_model_id) }
end
