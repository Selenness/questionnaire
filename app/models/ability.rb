require 'cancan'
class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user =  user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
    can :create, Comment
  end

  def user_abilities
    guest_abilities
    can :set_best, Answer do |answer|
      user.author_of?(answer.question)
    end
    can :create, [Question, Answer, UserVote]
    can :update, [Question, Answer, Comment, UserVote], user: user
    can :destroy, [Question, Answer, Comment, UserVote], user: user
  end
end
