RSpec.describe PatronsController do
  describe '#index' do
    before do
      create_list(:shareholder, 2)
      create_list(:representative, 2)

      get :index
    end

    after do
      Patron.delete_all
    end

    subject { json }

    it { is_expected.to be_a Hash }
    it { is_expected.to include 'data', 'meta' }

    describe "response.body['data']" do
      subject { json['data'] }

      it { is_expected.to be_an Array }
      its(:length) { is_expected.to be > 0 }
    end

    describe "response.body['meta']" do
      subject { json['meta'] }

      it { is_expected.to be_a Hash }
      it { is_expected.to include 'page', 'total_pages', 'per_page', 'total' }
    end
  end

  describe '#search' do
    let(:query) { 'Kermit' }

    before do
      create(:patron, name: "Kermit, #{query}")
      get :search, params: { q: query }
    end

    describe 'response.body' do
      subject { json }

      it { is_expected.to be_a Hash }
      it { is_expected.to include 'data', 'meta' }
    end

    describe "response.body['data']" do
      subject { json['data'] }

      it { is_expected.to be_an Array }
      its(:length) { is_expected.to be > 0 }
    end
  end

  describe '#show' do
    subject { json }

    let(:patron) { create(:patron) }

    before do
      get :show, params: { id: patron.id }
    end

    it { is_expected.to be_a Hash }
    it { is_expected.to include 'name', 'types', 'id' }
    it { is_expected.not_to include 'drupal_node_id', 'drupal_node_type' }
  end
end
