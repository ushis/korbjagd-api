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
    record.user.nil? || record.user == user || user.admin?
  end

  def destroy?
    update?
  end

  def permitted_attributes
    attrs = [:name, category_ids: []]

    if !record.persisted? || user.admin?
      attrs.concat([:latitude, :longitude])
    else
      attrs
    end
  end
end
