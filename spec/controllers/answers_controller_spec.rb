require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  before { @question = FactoryGirl.create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #new' do
    before {  get :new, params: { question_id: @question.id } }

    it 'assigns new answer to Answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { question_id: @question.id, answer: attributes_for(:answer) } }.to change(@question.answers, :count).by(1)
      end

      it 'render show view' do
        post :create, params: { question_id: @question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the database' do
        expect { post :create, params: { question_id: @question.id, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 'render new view' do
        post :create, params: { question_id: @question.id, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :new
      end
    end
  end
end
