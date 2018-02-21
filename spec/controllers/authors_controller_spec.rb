RSpec.describe AuthorsController do
  describe 'GET #index' do
    before do
      get :index
    end

    subject { json }

    it { is_expected.to include 'data', 'meta' }

    describe "response.body['data']" do
      subject { json['data'] }

      it { is_expected.to be_an Array }
    end

    describe "response.body['meta']" do
      subject { json['meta'] }

      it { is_expected.to be_a Hash }
      it { is_expected.to include 'total', 'page', 'per_page', 'total_pages' }
    end
  end

  describe 'GET #search' do
    let(:name) { 'Piggy, Miss' }
    let!(:target) { create(:author, name: name) }
    let!(:pool) { create_list(:author, 20) }

    before do
      get :search, params: { q: name }
    end

    after do
      target.delete
      pool.each(&:delete)
    end

    describe 'response.body' do
      subject { json }

      it { is_expected.to include 'data', 'meta' }
    end

    describe "response.body['data']" do
      subject { json['data'] }

      it { is_expected.not_to be_empty }
      its(:length) { is_expected.to eq 1 }
    end
  end

  describe 'GET #show' do
    before do
      target = create(:author, name: 'Piggy, Miss')
      get :show, params: { id: target.id }
    end

    describe 'its payload object' do
      subject { json }

      it { is_expected.to be_a Hash }
      it { is_expected.to include 'name', 'id', 'types' }
      it { is_expected.not_to include 'drupal_node_id', 'drupal_node_type' }
    end
  end
end
