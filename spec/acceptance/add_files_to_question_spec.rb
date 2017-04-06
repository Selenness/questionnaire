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

  scenario 'User add files when make a question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
  end
end
