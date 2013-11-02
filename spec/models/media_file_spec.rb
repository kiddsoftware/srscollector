require 'spec_helper'

describe MediaFile do
  it { should belong_to(:card) }
  it { should validate_presence_of(:card) }
  it { should have_attached_file(:file) }

  it { should validate_attachment_presence(:file) }
  it { should validate_attachment_content_type(:file).
         allowing('image/png', 'image/gif', 'image/jpg').
         rejecting('text/plain', 'text/html') }
  it { should validate_attachment_size(:file).less_than(128.kilobytes) }
end
