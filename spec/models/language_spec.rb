require 'spec_helper'

describe Language do
  it { should have_many(:cards) }
  it { should have_many(:dictionaries_from).class_name("Dictionary") }
  it { should have_many(:dictionaries_to).class_name("Dictionary") }

  it { should validate_presence_of(:iso_639_1) }
  it { should validate_presence_of(:name) }
end
