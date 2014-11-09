class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user

    return guest_abilities if !user

    if user.admin?
      admin_abilities
    elsif !user.email_verified?
      unconfirmed_user_abilities
    else 
      user_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def unconfirmed_user_abilities
    guest_abilities
    can :finish_signup, User
    can :update_profile, User
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer, Comment], author: user
  end
end
