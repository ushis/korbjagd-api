class WelcomeMailJob < ApplicationJob

  def perform(user)
    UserMailer.welcome(user).deliver
  end
end
