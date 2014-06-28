class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
  end

  def show?
    record == user
  end

  def create?
    true
  end

  def update?
    record == user
  end

  def destroy?
    record == user
  end

  def permitted_attributes
    [:username, :email, :password, :password_confirmation]
  end
end
