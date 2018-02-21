RSpec.describe LedgersController do
  let!(:ledger) { Ledger.create }

  describe '#index' do
    before do
      get :index
    end

    describe 'response.body' do
      subject { json }

      it { is_expected.to be_a Hash }
      it { is_expected.to include 'data', 'meta' }
    end

    describe "response.body['data']" do
      subject { json['data'] }

      it { is_expected.to be_an Array }
    end

    describe "response.body['meta']" do
      subject { json['meta'] }

      it { is_expected.to be_a Hash }
      it { is_expected.to include 'page', 'per_page', 'total', 'total_pages' }
    end
  end

  describe '#show' do
    before do
      get :show, params: { id: ledger.id }
    end

    subject { json }

    it { is_expected.to be_a Hash }
    it { is_expected.to include 'id', 'loans' }
    its(:count) { is_expected.to be_an Integer }
  end
end
