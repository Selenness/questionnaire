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
      expect(question.user.author_of?(question)).to eq true
    end

    it "returns false if user is not question's author" do
      expect(user.author_of?(question)).to eq false
    end

    it "returns true if user is answer's author" do
      answ = question.answers.first
      expect(answ.user.author_of?(answ)).to eq true
    end

    it "returns false if user is not answer's author" do
      answ = question.answers.first
      expect(user.author_of?(answ)).to eq false
    end
  end
end