class Question < ApplicationRecord

  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  has_many :notifications
  has_many :subscribers, class_name: 'User', through: :notifications, source: :user
  # has_many :user_votes, as: :votable
  belongs_to :user
  validates :title, :body, presence: true

   accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :subscribe_author

  def to_search_result
    { title: self.title, body: self.body }
  end

  private

  def subscribe_author
    self.notifications.create(user_id: self.user_id)
  end
end
