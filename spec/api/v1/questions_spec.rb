require 'spec_helper'

RSpec.describe 'Questions API', type: :request do
  describe 'GET /index' do

    it_behaves_like 'API Authenticable'

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns questions list' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do

          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
      end

      context 'answers' do
        it 'included in question oject' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do

    it_behaves_like 'API Authenticable'

    let!(:question) { create(:question) }

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end

    context 'authorized' do
      let!(:question) { create(:question) }
      let!(:attachment) { create_list(:attachment, 2, attachable: question) }
      let!(:comment) { create_list(:comment, 2, commentable: question) }
      let!(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token, question_id: question.id } }

      it 'returns question with attachments' do
        expect(response.body).to have_json_size(2).at_path('attachments')
      end

      it 'returns question with comments' do
        expect(response.body).to have_json_size(2).at_path('comments')
      end
    end
  end

  describe "POST #create" do
    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context "with invalid attributes" do
        it 'returns 422 status' do
          post "/api/v1/questions", params: {
              question: attributes_for(:invalid_question),
              access_token: access_token.token,
              format: :json
          }
          expect(response.status).to eq 422
        end

        it 'doesnt create question in database' do
          expect { post "/api/v1/questions",
                        params: {
                            question: attributes_for(:invalid_question),
                            access_token: access_token.token,
                            format: :json
                        }
          }.to_not change(Question, :count)
        end
      end

      context "with valid attributes" do
        it 'returns success status' do
          post "/api/v1/questions",
               params: {
                   question: attributes_for(:question),
                   access_token: access_token.token,
                   format: :json
               }
          expect(response).to be_success
        end

        it 'creates question in database' do
          expect { post "/api/v1/questions",
                        params: {
                            question: attributes_for(:question),
                            access_token: access_token.token,
                            format: :json
                        }
          }.to change(Question, :count).by(1)
        end
      end
    end
  end
end