# Connect to Redis if we have a URL.  If we don't, we're probably building
# assets on Heroku.
if ENV["REDISTOGO_URL"]
 begin
   uri = URI.parse(ENV["REDISTOGO_URL"])
   REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
   # Always put the test environment in a high-numbered database.
   REDIS.select(15) if Rails.env.test?
 end
else
  REDIS = nil
end
