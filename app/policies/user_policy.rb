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
    attrs = [:email, :notifications_enabled, :password, :password_confirmation]

    if !record.persisted? || user.admin?
      attrs << :username
    else
      attrs
    end
  end
end
