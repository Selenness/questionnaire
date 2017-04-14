class UserVote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, dependent: :destroy

  validates :pro, presence: true, format: /\A[+-]?1\z/
end
