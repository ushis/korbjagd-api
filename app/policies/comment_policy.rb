class CommentPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    record.user == user && record.created_at > 15.minutes.ago
  end

  def destroy?
    record.user == user
  end

  def permitted_attributes
    [:comment]
  end
end
