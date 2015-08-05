class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, User
      can :manage, Organization
    end
    can :manage, Inventory if user.organization
  end
end
