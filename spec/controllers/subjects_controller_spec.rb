RSpec.describe SubjectsController do
  describe 'GET #show' do
    before do
      get :show, params: { id: subject.id }
    end

    let(:subject) { create(:subject, label: 'Cool Subject') }

    it 'has a successful http response' do
      expect(response).to have_http_status(:success)
    end

    it 'has an "application/json" content-type' do
      expect(response.content_type).to eq 'application/json'
    end
  end
end