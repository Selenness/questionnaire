class Answer < ApplicationRecord

  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable
  # has_many :user_votes, as: :votable

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  default_scope { order('best desc') }

  after_create :notify

  def set_best
    ActiveRecord::Base.transaction do
      reset_best
      self.update_attribute(:best, true)
    end
  end

  def to_search_result
    { title: self.question.title, body: self.body }
  end


  private

  def notify
    NotifyJob.perform_later self
  end

  def reset_best
    self.question.answers.update_all(best: false)
  end
end
