class CommentMailer < ApplicationMailer

  def new_comment(user, basket, comment)
    @user = user
    @basket = basket
    @comment = comment
    @url = app_url("/#/baskets/#{@basket.id}/comments")
    mail(to: @user.email_with_name, subject: new_comment_subject)
  end

  private

  def new_comment_subject
    if @user == @basket.user
      "#{@comment.user.username} left a comment on your basket #{@basket.name}"
    else
      "#{@comment.user.username} left a comment in the discussion about #{@basket.name}"
    end
  end
end
