require 'rails_helper'

RSpec.describe User do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should validate_presence_of (:email )}
  it { should validate_presence_of (:password) }

  describe 'it checks if user is author of' do
    let(:question) { create(:question, :with_answers) }
    let(:user) { create(:user) }

    it "returns true if user is question's author" do
      expect(question.user).to be_author_of(question)
    end

    it "returns false if user is not question's author" do
      expect(user).not_to be_author_of(question)
    end

    it "returns true if user is answer's author" do
      answ = question.answers.first
      expect(answ.user).to be_author_of(answ)
    end

    it "returns false if user is not answer's author" do
      answ = question.answers.first
      expect(user).not_to be_author_of(answ)
    end
  end
end