class Question < ApplicationRecord
  has_many :answers, -> { joins(:question).order('questions.best_answer_id = answers.id desc, answers.created_at')}, dependent: :destroy
  belongs_to :user
  validates :title, :body, presence: true
end
