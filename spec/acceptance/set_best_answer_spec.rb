require_relative 'acceptance_helper'

feature 'Set best answer', %q{
  For best answer choice
  As an author of question
  I want to be able to set up best answer
}do

  let(:question) { create(:question, :with_answers) }
  let!(:answer1) { create(:answer, question: question, user: create(:user)) }
  before {
    sign_in(question.user)
  }

  scenario 'Set up the best answer', js: true do
    visit question_path(question)
    within "#span_answer_#{question.answers.first.id}" do
      choose 'best_answer'
    end
    expect(page).to have_content "Best answer was successfully set"
  end

  scenario 'Change best answer', js: true do
    visit question_path(question)
    within "span#span_answer_#{question.answers.first.id}" do
      choose "best_answer"
    end
    within "span#span_answer_#{answer1.id}" do
      choose "best_answer"
    end
    expect(page).to have_content "Best answer was successfully set"
  end

end