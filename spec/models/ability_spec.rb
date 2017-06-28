require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :create, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question) }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, UserVote }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other), user: user }

    it { should be_able_to :update, create(:answer, question: question, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, question: question, user: other), user: user }

    it { should be_able_to :update, create(:user_vote, votable: question, user: user, pro: true), user: user }
    it { should_not be_able_to :update, create(:user_vote, votable: question, user: other, pro: true), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: other), user: user }

    it { should be_able_to :destroy, create(:answer, question: question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, question: question, user: other), user: user }

    it { should be_able_to :destroy, create(:user_vote, votable: question, user: user, pro: true), user: user }
    it { should_not be_able_to :destroy, create(:user_vote, votable: question, user: other, pro: true), user: user }
  end
end