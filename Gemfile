ruby "2.0.0"

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use HAML for templates.
gem 'haml-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Ember.js for client-side JavaScript.  Emblem gives us beautiful templates.
gem 'ember-rails'
gem 'emblem-rails'

# Lock these to the exact versions we use in bower.json, or as close as we
# can get, in the case of handlebars.  We're not supposed to use these
# copies at all, but things like emblem-rails keep picking them up, so at
# least get sane versions.
gem 'handlebars-source', '~> 1.0.0'
gem 'ember-source', '= 1.0.0'
gem 'ember-data-source', '= 1.0.0.beta.3'

# Used to remove suspicious junk from HTML on cards.
gem 'sanitize'

# HTTP language detector.
gem 'http_accept_language'

# A simple HTTP client.
gem 'httparty'

# Compact language detector, courtesy of the Google Chrome team.
gem 'cld'

# The most robust encoding detector I can find.  Huge and very slow to
# install, but it's the only one that gives reasonable answers for a wide
# range of encodings.
gem 'charlock_holmes_bundle_icu'

# Release features to users gradually.  This gem is a little primitive, but
# it's actively maintained and installs cleanly, which is not always the
# case with feature flag gems.
gem 'rollout'
gem 'redis'

# A concurrent webserver.
# http://blog.codeship.io/2013/10/16/unleash-the-puma-on-heroku.html
gem 'puma'

# Password management.
gem 'bcrypt-ruby', '~> 3.0.0'

# File attachments.
gem 'paperclip'
gem 'aws-sdk'
gem 'zipruby'

# Translation.
gem 'easy_translate'

# Cleaning up after Google Translate API.
gem 'htmlentities'

# Admin.
gem "cancan"
gem 'activeadmin', github: 'gregbell/active_admin'

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end

group :development do
  gem 'foreman'
  gem 'dotenv-rails'
  gem 'guard'
  gem 'guard-rspec', require: false
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'sqlite3'
  gem 'rspec-rails', '~> 2.0'
end

group :test do
  gem 'poltergeist'
  gem 'capybara-screenshot'
  gem "show_me_the_cookies"
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'webmock'
  gem 'vcr'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
