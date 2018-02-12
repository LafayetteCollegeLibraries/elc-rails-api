RSpec.describe SubjectsController do
  describe 'GET #index' do
    before do
      get :index
    end

    let(:target) { create(:subject) }

    subject { json }

    it { should include 'data', 'meta' }

    describe 'response.body["data"]' do
      subject { json['data'] }
      it { should be_an Array }
    end

    describe 'response.body["meta"]' do
      subject { json['meta'] }

      it { should be_a Hash }
    end
  end

  describe 'GET #show' do
    before do
      get :show, params: { id: target.id }
    end

    let(:target) { create(:subject, label: 'Cool Subject') }

    subject { json }

    it { should include 'label', 'id' }
    it { should_not include 'drupal_node_id', 'drupal_node_type' }
  end
end