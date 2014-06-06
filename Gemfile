source 'http://rubygems.org'

ruby '2.1.1'

gem 'rails', '4.1'

gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'devise'
gem 'bootstrap-sass'
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'i18n'
gem 'friendly_id'
gem 'rabl'
gem 'pg'

group :development, :test do
  gem 'spring'
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'debugger'
  gem 'factory_girl_rails'
  gem 'letter_opener'
end

group :test do
  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'database_cleaner'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :staging, :production do
  gem 'thin'
end
