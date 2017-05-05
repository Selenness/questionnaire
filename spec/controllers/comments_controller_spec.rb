require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST#create' do
    sign_in_user
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: create(:user)) }
    context 'with valid params' do
      it 'creates comment to question' do
        expect { post :create, params: {
            comment: attributes_for(:comment).merge(commentable_id: question.id, commentable_type: question.class.name)
        }}.to change(question.comments, :count).by(1)
      end

      it 'creates comment to answer' do
        expect { post :create, params: {
            comment: attributes_for(:comment).merge(commentable_id: answer.id, commentable_type: answer.class.name)
        }}.to change(answer.comments, :count).by(1)
      end
    end

    context 'with invalid params' do
      it "doesn't create comment to question" do
        expect { post :create, params: {
            comment: attributes_for(:invalid_comment).merge(commentable_id: question.id, commentable_type: question.class.name)
        }}.not_to change(question.comments, :count)
      end

      it "doesn't create comment to answer" do
        expect { post :create, params: {
            comment: attributes_for(:invalid_comment).merge(commentable_id: answer.id, commentable_type: answer.class.name)
        }}.not_to change(answer.comments, :count)
      end
    end
  end
end