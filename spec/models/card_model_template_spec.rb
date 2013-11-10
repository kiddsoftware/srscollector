require 'spec_helper'

describe CardModelTemplate do
  it { should belong_to(:card_model) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:anki_front_template) }
  it { should validate_presence_of(:anki_back_template) }
end
