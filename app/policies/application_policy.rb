class ApplicationPolicy < Struct.new(:user, :record)
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.none
    end
  end

  def show?
    false
  end

  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end
end
