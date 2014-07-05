class GoodbyeMailJob < ApplicationJob

  def perform(user)
    UserMailer.goodbye(user).deliver
  end
end
