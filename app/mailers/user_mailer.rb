class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
    @url = app_url('/#/signin')
    mail(to: @user.email_with_name, subject: 'Welcome to Korbjagd')
  end

  def password_reset(user)
    @user = user
    @url = app_url("/#/password/reset/#{@user.auth_token}")
    mail(to: @user.email_with_name, subject: 'Korbjagd Password Reset')
  end
end
