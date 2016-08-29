class UserAccountWorker
  include Sidekiq::Worker

  def perform(user_id, password)
    user = User.find_by_id(user_id)
    UserMailer.notificate_user_account(user, password).deliver
  end
end
