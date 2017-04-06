require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, :with_user_id) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    before { get :show, id: question }
    let(:question) { create(:question, :with_answers) }

    it 'assigns the requested question to question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns the answers to question' do
      expect(assigns(:question).answers).to match_array(question.answers)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'builds new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assigns requested question to question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(id: assigns(:question).id)
      end
    end

    context 'with invalid attributes' do
      it 'does not save question to the database' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'valid attributes' do
      it 'assigns requested question to question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: "new_title", body: "new_body" }
        question.reload
        expect(question.title).to eq 'new_title'
        expect(question.body).to eq 'new_body'
      end

      it 'redirect to updated question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end

    end

    context 'invalid attributes' do
      before { patch :update, id: question, question: { title: "new_title", body: nil } }
      it 'does not change question attributes' do

        question.reload
        expect(question.title).not_to eq 'new_title'
        expect(question.body).not_to eq nil
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:question) { create(:question, :with_answers) }

    it 'it deletes question belonging to user' do
      sign_in(question.user)
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'deletes question belonging to other user' do
      expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
    end

    it 'it redirects to index view' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
