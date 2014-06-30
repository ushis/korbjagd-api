class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
  end

  def show?
    record == user || user.admin?
  end

  def create?
    true
  end

  def update?
    record == user || user.admin?
  end

  def destroy?
    record == user || user.admin?
  end

  def permitted_attributes
    if !record.persisted? || user.admin?
      [:username, :email, :password, :password_confirmation]
    else
      [:email, :password, :password_confirmation]
    end
  end
end
