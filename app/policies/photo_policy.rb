class PhotoPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
  end

  def show?
    true
  end

  def create?
    BasketPolicy.new(user, record.basket).update?
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
