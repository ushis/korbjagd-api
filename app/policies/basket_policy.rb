class BasketPolicy < ApplicationPolicy
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
    create?
  end

  def destroy?
    update?
  end

  def permitted_attributes
    [:name, :longitude, :latitude, :description, category_ids: []]
  end
end
