require 'spec_helper'

describe PlayableMedia do
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }

  it { should belong_to(:language) }
  it { should validate_presence_of(:language) }

  it { should validate_presence_of(:type) }  
  it { should ensure_inclusion_of(:type).in_array(['audio', 'video']) }

  it { should validate_presence_of(:url) }
end
