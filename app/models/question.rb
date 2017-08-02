class Question < ApplicationRecord

  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  has_many :notifications
  has_and_belongs_to_many :subscribers, class_name: 'User', join_table: :notifications, through: :notifications
  # has_many :user_votes, as: :votable
  belongs_to :user
  validates :title, :body, presence: true

   accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :comments, reject_if: :all_blank, allow_destroy: true

  after_create :subscribe_author

  private

  def subscribe_author
    Notification.create(user_id: self.user_id, question_id: self.id)
  end
end
