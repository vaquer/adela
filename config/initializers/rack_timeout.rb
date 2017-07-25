Rack::Timeout.service_timeout = ENV['RACK_TIMEOUT'].to_i || 10 if Rails.env.production?
