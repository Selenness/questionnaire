require 'rails_helper'

RSpec.describe 'Answer API', type: :request do
  let!(:user) { create(:user) }
  let!(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe "GET #index" do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question) }

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers", params: { question_id: question.id, access_token: access_token.token, format: :json } }

      it 'returns success status' do
        expect(response).to be_success
      end

      it 'returns list of answers for question' do
        expect(response.body).to have_json_size(3)
      end

      %w(id body created_at updated_at user_id).each do |attr|
        it "contains answer item with #{attr}" do
          expect(response.body).to be_json_eql(answers.first.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe 'GET #show' do
    after :each do
      FileUtils.rm_rf(Dir["#{Rails.root}/public/test_uploads"])
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }
      let!(:comments) { create_list(:comment, 2, commentable: answer) }
      let!(:attachments) { create_pair(:attachment, attachable: answer) }

      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { access_token: access_token.token, format: :json } }

      it 'returns status success' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at user_id).each do |attr|
        it "contains answer item with #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      it 'returns answer with permit attributes' do
        expect(response).to match_response_schema("answer")
      end

      it 'returns answer with comments included' do
        expect(response.body).to have_json_size(2).at_path("comments")
      end

      context "attachments" do
        it 'returns answer with attachments included' do
          expect(response.body).to have_json_size(2).at_path("attachments")
        end
      end
    end
  end

  describe "POST #create" do
    let!(:question) { create(:question) }

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context "with invalid attributes" do
        it 'returns 422 status' do
          post "/api/v1/questions/#{question.id}/answers",
               params: {
                   answer: attributes_for(:invalid_answer),
                   access_token: access_token.token,
                   format: :json
               }
          expect(response.status).to eq 422
        end

        it 'doesnt create answer in database' do
          expect { post "/api/v1/questions/#{question.id}/answers",
                        params: {
                            answer: attributes_for(:invalid_answer),
                            access_token: access_token.token, format: :json
                        }
          }.to_not change(Answer, :count)
        end
      end

      context "with valid attributes" do
        it 'returns success status' do
          post "/api/v1/questions/#{question.id}/answers", params: {
              answer: attributes_for(:answer),
              access_token: access_token.token,
              format: :json
          }
          expect(response.status).to eq 201
        end

        it 'creates answer in database' do
          expect { post "/api/v1/questions/#{question.id}/answers",
                        params: {
                            answer: attributes_for(:answer),
                            access_token: access_token.token,
                            format: :json
                        }
          }.to change(Answer, :count).by(1)
        end
      end

    end
  end
end