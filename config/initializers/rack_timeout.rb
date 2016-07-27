Rack::Timeout.service_timeout = ENV['RACK_TIMEOUT'] || 10 if Rails.env.production?
