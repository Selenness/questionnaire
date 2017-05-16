require 'rails_helper'

RSpec.describe User do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should validate_presence_of (:email )}
  it { should validate_presence_of (:password) }

  describe '.find for oauth'do
    let!(:user) { create(:user) }
    let (:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user has already authorizaton' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists'do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.not_to change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user'do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

        it 'create new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end
        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).not_to be_empty
        end
        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

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