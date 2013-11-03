require 'spec_helper'

describe MediaFile do
  it { should belong_to(:card) }
  it { should validate_presence_of(:card) }

  it { should have_attached_file(:file) }
  it { should validate_attachment_presence(:file) }
  it { should validate_attachment_size(:file).less_than(128.kilobytes) }
  it { should validate_presence_of(:file_fingerprint) }

  describe "#file" do
    let(:card) { FactoryGirl.create(:card) }
    it "stores file data" do
      image_url = stub_image_url
      card.media_files.create!(url: image_url)
      card.media_files.length.should == 1
      mf = card.media_files[0]
      mf.file.url.should_not be_nil
      mf.file_content_type.should == 'image/png'
      # This gets changed by our styles: original configuration.
      #mf.file_fingerprint.should == "5caea4b25b1b833d056b17e7d24f6fb9"
    end
  end
end
