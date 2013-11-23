# Set up our HTTP recording/playback system for use during specs, so
# we don't hit Google APIs, etc., every time we run unit tests.
VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
  c.filter_sensitive_data('<GOOGLE_API_KEY>') { EasyTranslate.api_key }
end
