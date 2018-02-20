RSpec.describe LoansController do
  let(:loan) { create(:loan) }

  describe '#index' do
    context 'when no params passed' do
      before do
        create(:loan)
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
        it { is_expected.not_to be_empty }
      end

      describe "response.body['meta']" do
        subject { json['meta'] }

        it { is_expected.to be_a Hash }
        it { is_expected.to include 'page', 'total', 'per_page', 'total_pages' }
      end
    end

    context 'when :ledger_id passed' do
      let(:loan) { create(:loan) }
      let(:ledger) { Ledger.create { |l| l.loans << loan } }

      before do
        get :index, params: { ledger_id: ledger.id }
      end

      describe 'response.data' do
        subject { json }

        it { is_expected.to be_a Hash }
        it { is_expected.to include 'data', 'meta' }
      end

      describe "response.body['data']" do
        subject { json['data'] }

        it { is_expected.to be_an Array }
        its(:length) { is_expected.to eq 1 }
      end
    end

    context 'when :work_id passed' do
      let(:work) { create(:work) }

      before do
        create(:loan, items: [create(:item, work: work)])
        get :index, params: { work_id: work.id }
      end

      describe 'response.body' do
        subject { json }

        it { is_expected.to be_a Hash }
        it { is_expected.to include 'data', 'meta' }
      end

      describe "response.body['data']" do
        subject { json['data'] }

        it { is_expected.to be_an Array }
        its(:length) { is_expected.to eq 1 }
      end
    end

    context 'when :patron_id passed + the patron is a shareholder' do
      let(:patron) { create(:shareholder) }

      before do
        create(:loan, shareholder: patron)
        get :index, params: { patron_id: patron.id }
      end

      describe 'response.body' do
        subject { json }

        it { is_expected.to be_a Hash }
        it { is_expected.to include 'data', 'meta' }
      end

      describe "response.body['data']" do
        subject { json['data'] }

        it { is_expected.to be_an Array }
        its(:length) { is_expected.to eq 1 }
      end
    end

    context 'when :patron_id passed + the patron is a representative' do
      let(:patron) { create(:representative) }

      before do
        create(:loan, representative: patron)
        get :index, params: { patron_id: patron.id }
      end

      describe 'response.body' do
        subject { json }

        it { is_expected.to be_a Hash }
        it { is_expected.to include 'data', 'meta' }
      end

      describe "response.body['data']" do
        subject { json['data'] }

        it { is_expected.to be_an Array }
        its(:length) { is_expected.to eq 1 }
      end
    end
  end

  describe '#show' do
    subject { json }

    let(:fields) do
      %w[
        id
        label
        work
        volumes
        issues
        years
        checkout_date
        return_date
        representative
        shareholder
        ledger
      ]
    end

    before do
      get :show, params: { id: loan.id }
    end

    it { is_expected.to be_a Hash }
    it { is_expected.to include(*fields) }
    it { is_expected.not_to include 'drupal_node_id', 'drupal_node_type' }
  end
end
