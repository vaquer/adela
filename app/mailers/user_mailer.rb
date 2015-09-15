# encoding: utf-8
class UserMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def notificate_user_account(user, password)
    @user = user
    @password = password
    mail(to: @user.email, from: MAILER_FROM, subject: I18n.t('mailers.user.notificate_user_account_subject')).deliver
  end
end
