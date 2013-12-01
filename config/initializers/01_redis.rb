# Connect to Redis.
begin
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(host: uri.host, port: uri.port)
  # Always put the test environment in a high-numbered database.
  REDIS.select(15) if Rails.env.test?
end
