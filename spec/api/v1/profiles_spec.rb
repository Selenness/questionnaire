require 'spec_helper'

RSpec.describe 'Profile API', type: :request do
  describe 'GET /me' do

    it_behaves_like 'API Authenticable'

    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token, format: :json } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).not_to have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /profiles_list' do

    it_behaves_like 'API Authenticable'

    def do_request(options = {})
      get '/api/v1/profiles/profiles_list', { format: :json }.merge(options)
    end

    context 'authorized' do
      let!(:me) { create(:user) }
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }

      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/profiles_list', params: { access_token: access_token.token, format: :json } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it "contains users" do
        users = [user1, user2].to_json
        expect(response.body).to eq users
      end
    end
  end
end
