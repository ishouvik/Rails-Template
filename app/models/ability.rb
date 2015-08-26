class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guests
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :user
      can :read, :all

      # User
      can :manage, User, :id => user.id

      # Models owned by User
      # can :manage, [Model], :user_id => user.id
    else
      can :read, :all
    end 
  end
end