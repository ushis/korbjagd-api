class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
    @url = app_url('/#/signin')
    mail(to: @user.email_with_name, subject: 'Welcome to Korbjagd')
  end

  def password_reset(user)
    @user = user
    @url = app_url("/#/password/reset/#{@user.password_reset_token}")
    mail(to: @user.email_with_name, subject: 'Korbjagd Password Reset')
  end

  def goodbye(user)
    @user = user
    @url = app_url("/#/signup")
    mail(to: @user.email_with_name, subject: 'Goodbye!')
  end
end
