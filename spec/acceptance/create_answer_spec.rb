require_relative 'acceptance_helper'

feature 'Create answer to question', %q{
  In order to give answer to question
  As an authenticate user
  I want to be able to create answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User creates invalid answer', js: true do
    sign_in(user)
    visit question_path(question)
    within '#answer_form' do
      fill_in 'Body', with: nil
      click_on 'Create'
    end
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Authenticate user create answer', js: true do
    sign_in(user)
    visit question_path(question)
    within '#answer_form' do
      fill_in 'Body', with: 'Test answer'
      click_on 'Create'
    end

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Test answer'
    end
  end

  scenario 'Non-authenticate user tries to create answer' do
    visit question_path(id: question.id)
    within '#answer_form' do
      expect(page).to_not have_selector("form#new_answer")
      fill_in 'Body', with: 'Test answer'
      click_on 'Create'
    end
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context 'multiple sessions' do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '#answer_form' do
          fill_in 'Body', with: 'Test answer'
          click_on 'Create'
        end
        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content 'Test answer'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test answer'
      end
    end
  end
end