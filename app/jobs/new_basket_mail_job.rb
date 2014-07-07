class NewBasketMailJob < ApplicationJob

  def perform(basket)
    ActiveRecord::Base.connection_pool.with_connection do
      User.admins.where.not(id: basket.user.id).each do |user|
        BasketMailer.new_basket(user, basket).deliver
      end
    end
  end
end
