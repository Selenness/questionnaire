require_relative 'acceptance_helper'

feature 'Searching', %q{
  In order to find information
  As an user
  I want to be able to search
}, sphinx: true do

  given!(:user) { create(:user, email: 'test@test.test') }
  given!(:question) { create(:question, user: user, title: 'test question title', body: 'test question body' ) }
  given!(:answer) { create(:answer, question: question, body: 'test answer body') }
  given!(:comment) { create(:comment, commentable_type: 'Answer', commentable_id: answer.id, text: 'test comment text')}

  background do
    index
  end

  scenario 'user search in question', js: true do
    visit root_path
    fill_in :term, with: 'question'
    choose "options_Question"

    click_on 'Search'
    # save_and_open_page
    within '.result' do
      expect(page).to have_content 'test question title'
      expect(page).to have_content 'test question body'
    end
  end

  scenario 'user search in answer', js: true do
    visit root_path
    fill_in :term, with: 'answer'
    choose "options_Answer"
    click_on 'Search'
    within '.result' do
      expect(page).to have_content answer.body
    end
  end

  scenario 'user search in comment', js: true do
    visit root_path
    fill_in :term, with: 'comment'
    choose "options_Comment"
    click_on 'Search'
    within '.result' do
     expect(page).to have_content comment.text
    end
  end

  scenario 'user search for all', js: true do
    visit root_path
    fill_in :term, with: 'test'

    click_on 'Search'
    within '.result' do
      expect(page).to have_content user.email
      expect(page).to have_content question.body
      expect(page).to have_content question.title
      expect(page).to have_content answer.body
      expect(page).to have_content comment.text
    end
  end

end

