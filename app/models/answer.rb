class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true

  default_scope { order('best_answer desc') }

  before_update :reset_best_answer

  private

  def reset_best_answer
    unless self.best_answer.nil?
      self.question.answers.update_all(best_answer: false)
    end
  end
end
