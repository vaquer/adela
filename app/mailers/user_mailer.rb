#encoding: utf-8;
class UserMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def notificate_user_account(user, password)
    @user = user
    @password = password
    to = @user.email
    mail(:to => to, :from => "no-reply@adela.com", :subject => I18n.t('mailers.user.notificate_user_account_subject')).deliver
  end
end