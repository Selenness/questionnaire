require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe 'DELETE #destroy' do

    let(:user) {create(:user)}
    let(:question) { create(:question, user: user) }
    let!(:attachment) {create(:attachment, attachable: question) }

    context 'current user is an author' do

      it 'removes attachment from database' do
        sign_in(user)
        expect { delete :destroy, params: { id: attachment }, format: :js }.to change(question.attachments, :count).by(-1)
      end

      it 'returns ok upon deletion' do
        sign_in(user)
        delete :destroy, params: { id: attachment }, format: :js
        expect(response.status).to eq 200
      end
    end

    context 'current user is not an author' do
      sign_in_user

      it 'does not remove attachment from database' do
        expect { delete :destroy, params: { id: attachment }, format: :js }.to_not change(question.attachments, :count)
      end

      it 'redirects to root path upon deletion' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(response).to redirect_to root_path
      end
    end

  end
end