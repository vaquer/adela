if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    :address        => ENV['MAILER_ADDRESS'],
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['MAILER_USERNAME'],
    :password       => ENV['MAILER_PASSWORD'],
    :domain         => ENV['MAILER_DOMAIN']
  }
  ActionMailer::Base.delivery_method = :smtp
end
