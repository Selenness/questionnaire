require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  describe "GET #create" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    it 'saves the new notification in the database' do
      sign_in(user)
      expect { post :create, params: { question_id: question.id, user_id: user.id }}.to change(Notification, :count).by(1)
    end
  end

  describe "GET #destroy" do
    let!(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:notification) { create(:notification, user_id: user.id, question_id: question.id) }

    it "delete notification from database" do
      sign_in(user)
      expect { delete :destroy, params: { question_id: question.id, user_id: user.id }}.to change(Notification, :count).by(-1)
    end
  end
end

