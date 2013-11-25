require 'spec_helper'

describe Dictionary do
  it { should belong_to(:from_language).class_name('Language') }
  it { should validate_presence_of(:from_language) }

  it { should belong_to(:to_language).class_name('Language') }
  it { should_not validate_presence_of(:to_language) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url_pattern) }
  it { should validate_presence_of(:score) }
end
