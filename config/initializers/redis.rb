uri = URI.parse(ENV["REDISTOGO_URL"]) unless Rails.env.test?
REDIS = Redis.new(:url => ENV['REDISTOGO_URL']) unless Rails.env.test?