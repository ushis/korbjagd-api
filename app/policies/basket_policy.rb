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
    recored.user == user || user.admin?
  end

  def destroy?
    recored.user == user || user.admin?
  end

  def permitted_attributes
    [:name, :longitude, :latitude, :description, category_ids: []]
  end
end
