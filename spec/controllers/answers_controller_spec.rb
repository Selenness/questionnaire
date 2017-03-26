require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  before { @question = FactoryGirl.create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in the database with connection with question' do
        expect { post :create, params: { question_id: @question.id, answer: attributes_for(:answer) } }.to change(@question.answers, :count).by(1)
      end

      it 'saves the new answers in the database with connection with user' do
        expect { post :create, params: { question_id: @question.id, answer: attributes_for(:answer) } }.to change(@user.answers, :count).by(1)
      end

      it 'render question show' do
        post :create, params: { question_id: @question.id, answer: attributes_for(:answer) }
        expect(response).to render_template 'questions/show'
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the database' do
        expect { post :create, params: { question_id: @question.id, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 'redirects to question' do
        post :create, params: { question_id: @question.id, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'Delete #destroy' do
    let!(:question) { create(:question, :with_answers) }
    sign_in_user

    it "does not delete other's answer" do
      expect { delete :destroy, params: { question_id: question.id, id: question.answers.first.id } }.not_to change(Answer, :count)
    end

    it 'deletes users answer' do
      sign_in(question.answers.first.user)
      expect { delete :destroy, params: { question_id: question.id, id: question.answers.first.id } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to question show' do
      delete :destroy, params: { question_id: question.id, id: question.answers.first.id }
      expect(response).to redirect_to question_path(id: question.id)
    end
  end
end
