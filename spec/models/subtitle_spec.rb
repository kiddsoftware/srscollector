require 'spec_helper'

describe Subtitle do
  it { should belong_to(:playable_media) }
  it { should validate_presence_of(:playable_media) }

  it { should belong_to(:language) }
  it { should validate_presence_of(:language) }

  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:end_time) }
  it { should validate_presence_of(:text) }

  # TODO: 'text' can contain <b><i><u> and <font color=...> only, interpret
  # as per HTML.
end
