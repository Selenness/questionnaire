require_relative 'acceptance_helper'

feature 'Index of quastions', %q{
  In order to find necessary quastion
  As an user
  I want to see all titles of questions
} do

  let!(:questions) { create_list(:question, 2) }

  scenario 'Any user could see any question' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end