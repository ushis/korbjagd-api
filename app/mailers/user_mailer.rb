class UserMailer < ActionMailer::Base

  def welcome(user)
    @user = user
    @url = "#{ENV['APP_HOST']}/#/signin"
    mail(to: @user.email_with_name, subject: 'Welcome to Korbjagd')
  end
end
