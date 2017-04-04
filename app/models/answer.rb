class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true

  default_scope { order('best desc') }

  def set_best
    ActiveRecord::Base.transaction do
      reset_best
      self.update_attribute(:best, true)
    end
  end

  private

  def reset_best
    self.question.answers.update_all(best: false)
  end
end
