module Votable
  extend ActiveSupport::Concern

  included do
    has_many :user_votes, as: :votable, dependent: :destroy
  end

  def voted_by?(user)
    self.user_votes.exists?(user_id: user.id)
  end

  def rate
    self.user_votes.sum(:pro)
  end

end




