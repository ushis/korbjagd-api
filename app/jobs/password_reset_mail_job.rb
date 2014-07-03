class PasswordResetMailJob < ApplicationJob

  def perform(user)
    UserMailer.password_reset(user).deliver
  end
end
