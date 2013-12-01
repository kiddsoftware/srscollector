ROLLOUT = Rollout.new(REDIS)

# We also use rollout to distinguish between paid and unpaid accounts, so
# we can make certain features available only to paid users.
ROLLOUT.define_group(:supporters) do |user|
  user.supporter?
end

# Features the client needs to know about.
ROLLOUT_CLIENT_FEATURES = [:playable_media]
