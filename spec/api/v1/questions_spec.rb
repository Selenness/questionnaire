require 'spec_helper'

RSpec.describe 'Questions API', type: :request do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'returns 200 status code' do
        get '/api/v1/questions', params: { access_token: access_token }
        expect(response).to be_success
      end
    end
  end
end