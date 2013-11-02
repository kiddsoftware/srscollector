require 'spec_helper'

describe MediaFile do
  it { should belong_to(:card) }
  it { should validate_presence_of(:card) }
  it { should have_attached_file(:file) }
end
