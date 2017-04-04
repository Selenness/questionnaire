require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  before { @question = FactoryGirl.create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new answer in the database with connection with question' do
        expect { post :create, params: { question_id: @question.id, answer: attributes_for(:answer), format: :js } }.to change(@question.answers, :count).by(1)
      end

      it 'saves the new answers in the database with connection with user' do
        expect { post :create, params: { question_id: @question.id, answer: attributes_for(:answer), format: :js } }.to change(@user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: @question.id, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the database' do
        expect { post :create, params: { question_id: @question.id, answer: attributes_for(:invalid_answer), format: :js  } }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: { question_id: @question.id, answer: attributes_for(:invalid_answer), format: :js  }
        expect(response).to render_template :create
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

  describe 'PATCH #update' do
    let!(:question) { create(:question, :with_answers) }
    before { sign_in(question.answers.first.user) }

    it 'assigns requested answer to @answer' do
      patch :update, params: { id: question.answers.first.id, answer: attributes_for(:answer), format: :js }
      expect(assigns(:answer)).to eq question.answers.first
    end

    it 'changes answer attributes' do
      patch :update, params: { question_id: question.id, id: question.answers.first.id, answer: { body: "new_body" }, format: :js }
      question.answers.first.reload
      expect(question.answers.first.body).to eq 'new_body'
    end

    it 'render update template' do
      patch :update, params: { question_id: question.id, id: question.answers.first.id, answer: attributes_for(:answer), format: :js }
      expect(response).to render_template :update
    end

    it 'sets best answer' do
      sign_in(question.user)
      answer1 = create(:answer, question: question, user: create(:user), best: true)
      answer2 = create(:answer, question: question, user: create(:user))
      patch :set_best, params: { question_id: question, id: answer2, answer: {best: true}, format: :js }
      expect(assigns(:answer).best?).to be true
      answer1.reload
      expect(answer1.best?).to be false
    end
  end
end
