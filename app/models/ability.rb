class Ability
  include CanCan::Ability
  		if user.has_role? :admin
  		  can :manage, :all
  		elsif user.has_role? :user
  			can :read, :all

  		 	# User
  			can :manage, User, :id => user.id
  		else
  			can :read, :all
  		end
	end
end