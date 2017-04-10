require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an author of question
  I'd like to be able attach file
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds files while making a question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text'
    first('input[type="file"]').set("#{Rails.root}/spec/spec_helper.rb")
    click_on('add file')
    all('input[type="file"]').last.set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Create'
    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
  end
end
