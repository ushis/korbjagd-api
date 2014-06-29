class AvatarPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
  end

  def show?
    true
  end

  def create?
    UserPolicy.new(user, record.user).update?
  end

  def update?
    create?
  end

  def destroy?
    update?
  end

  def permitted_attributes
    [:image]
  end
end
