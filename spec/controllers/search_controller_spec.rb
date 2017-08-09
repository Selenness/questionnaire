require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "POST #search" do
    let(:term) { 'test' }

    it "calls search for term" do
      expect(SearchForTerm).to receive_message_chain(:new, :call)
      get :search, params: { term: term }
    end

    it 'renders search result view' do
      get :search, params: { term: term }
      expect(response).to render_template 'search'
    end
  end
end
