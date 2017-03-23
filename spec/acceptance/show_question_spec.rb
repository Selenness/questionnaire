require 'rails_helper'

feature 'Show question', %q{
  In order to read all answers to question
  As user
  I want to see question with all answers
} do

  let(:question) { FactoryGirl.create :question, :with_answers }

  scenario 'Show question with answers' do
    visit question_path(id: question.id)
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    question.answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end