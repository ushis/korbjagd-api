class CategoryPolicy < ApplicationPolicy
  class CategoryPolicy::Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
