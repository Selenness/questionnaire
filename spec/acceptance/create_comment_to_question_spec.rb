require_relative 'acceptance_helper'

feature 'Create comment to question', %q{
  In order to give comments to questions
  As an any user
  I want to be able to create comment
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User creates comment', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question_comments' do
      fill_in 'Comment', with: 'Text of comment'
      click_on 'Create'
    end
    within '.question_comments' do
      expect(page).to have_content 'Text of comment'
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
        comments_div = find ".question_comments"
        within comments_div  do
          form = find('#new_comment')
          within form do
            fill_in 'Comment', with: 'Text of comment'
            click_on 'Create'
          end
        end

        within comments_div do
          expect(page).to have_content 'Text of comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Text of comment'
      end
    end
  end
end