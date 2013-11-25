require 'spec_helper'

describe Language do
  it { should have_many(:cards) }

  it { should validate_presence_of(:iso_639_1) }
  it { should validate_presence_of(:name) }
end
