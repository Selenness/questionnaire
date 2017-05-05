require_relative 'acceptance_helper'

feature 'Create comment to answer', %q{
  In order to give comments to answers
  As an any user
  I want to be able to create comment
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user)}

  scenario 'User creates valid comment', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answer_comments' do
      find('textarea').send_keys 'Text of comment'
      # fill_in 'Comment', with: 'Text of comment'
      click_on 'Create'
    end
    within '.answer_comments' do
      expect(page).to have_content 'Text of comment'
    end
  end

  scenario 'User is unable to create empty comment', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answer_comments' do
      expect(page).to have_css '[disabled="disabled"]'
    end
  end

  context 'multiple sessions' do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answer_comments' do
          find('textarea').send_keys 'Text of comment'
          # fill_in 'Comment', with: 'Text of comment'
          click_on 'Create'
        end
        expect(current_path).to eq question_path(question)
        within '.answer_comments' do
          expect(page).to have_content 'Text of comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Text of comment'
      end
    end
  end
end