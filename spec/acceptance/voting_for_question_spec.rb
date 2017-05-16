require_relative 'acceptance_helper'

feature 'Voting for the best question', %q{
  In order to define the best question
  As an authenticate user
  I want to be able to vote
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  let(:user_vote) { create(:user_vote, user: create(:user), votable: question, pro: 1)}

  scenario 'Non-authenticated user does not see vote buttons, but rate' do
    visit questions_path
    expect(page).not_to have_content 'Like'
    expect(page).not_to have_content 'Dislike'
    within '.rate' do
      expect(page).to have_content '0'
    end

  end

  scenario 'Author sees rate, does not see vote buttons', js: true do
    sign_in(question.user)
    visit questions_path
    expect(page).not_to have_content 'Like'
    expect(page).not_to have_content 'Dislike'
    within '.rate' do
      expect(page).to have_content '0'
    end
  end

  scenario "Non-author hasn't voted yet can vote up", js: true do
    sign_in(user)
    visit questions_path
    click_on 'Like'

    within '.rate'do
      expect(page).to have_content '1'
    end
  end

  scenario "Non-author hasn't voted yet can vote down", js: true do
    sign_in(user)
    visit questions_path
    click_on 'Dislike'

    within '.rate'do
      expect(page).to have_content '-1'
    end
  end

  scenario "Non-author has voted can reset his voice", js: true do
    sign_in(user_vote.user)

    visit questions_path

    click_on 'Reset'

    within '.rate'do
      expect(page).to have_content '0'
    end
    expect(page).to have_content 'Like'
    expect(page).to have_content 'Dislike'
    expect(page).not_to have_content 'Reset'
  end
end