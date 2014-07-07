class NewCommentMailJob < ApplicationJob

  def perform(comment)
    ActiveRecord::Base.connection_pool.with_connection do
      mail_basket_owner(comment)
      mail_commenters(comment)
    end
  end

  private

  def mail_basket_owner(comment)
    basket = comment.basket

    if basket.user != comment.user && basket.user.try(:notifications_enabled?)
      CommentMailer.new_comment(basket.user, basket, comment).deliver
    end
  end

  def mail_commenters(comment)
    basket = comment.basket
    exclude = [basket.user.try(:id), comment.user.id]
    recipients = basket.commenters.reachable.where.not(id: exclude)

    recipients.each do |user|
      CommentMailer.new_comment(user, basket, comment).deliver
    end
  end
end
