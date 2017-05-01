require 'rails_helper'

RSpec.describe UserVotesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, user: create(:user), question: question) }
  let!(:user_vote) { create(:user_vote, user: create(:user), votable: answer, pro: 1)}
  before { sign_in user }

  describe 'POST#create vote' do
    context 'valid attributes' do
      it 'saves new pro vote to the database' do
        expect { post :create, params: { user_vote: { pro: 1, votable_type: 'Answer', votable_id: answer.id }}, format: :js }.to change(UserVote, :count).by(1)
      end

      it 'saves new contra vote to the database' do
        expect { post :create, params: { user_vote: { pro: -1, votable_type: 'Answer', votable_id: answer.id }}, format: :js }.to change(UserVote, :count).by(1)
      end
    end

    context 'invalid attributes' do
      it 'not saves new vote to the database' do
        expect { post :create, params: { user_vote: { pro: 2, votable_type: 'Answer', votable_id: answer.id }}, format: :js }.not_to change(UserVote, :count)
      end

      it 'not saves new vote if user votes twice' do
        sign_in user_vote.user
        expect { post :create, params: { user_vote: { pro: 1, votable_type: 'Answer', votable_id: answer.id }}, format: :js }.not_to change(UserVote, :count)
      end

      it 'not save new vote if user is author' do
        sign_in answer.user
        expect { post :create, params: { user_vote: { pro: 1, votable_type: 'Answer', votable_id: answer.id }}, format: :js }.not_to change(UserVote, :count)
      end
    end


  end

  describe 'DELETE#destroy vote' do
    it 'deletes own vote' do
      sign_in(user_vote.user)
      expect { delete :destroy, params: { id: user_vote.id }, format: :js }.to change(UserVote, :count).by(-1)
    end

    it 'deletes other\'s vote' do
      sign_in(user)
      expect { delete :destroy, params: { id: user_vote.id }, format: :js }.not_to change(UserVote, :count)
    end
  end
end