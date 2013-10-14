require 'spec_helper'

describe Dictionary do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:to_lang) }
  it { should validate_presence_of(:from_lang) }
  it { should validate_presence_of(:url_pattern) }
  it { should validate_presence_of(:score) }
end
