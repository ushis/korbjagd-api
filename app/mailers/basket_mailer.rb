class BasketMailer < ApplicationMailer

  def new_basket(user, basket)
    @user = user
    @basket = basket
    @url = app_url("/#/baskets/#{@basket.id}/details")
    mail(to: @user.email_with_name, subject: new_basket_subject)
  end

  private

  def new_basket_subject
    "#{@basket.user.username} added the new basket #{@basket.name}"
  end
end
