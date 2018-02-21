RSpec.describe HomeController do
  before do
    get :index
  end

  describe 'the base object' do
    subject { json }

    it { is_expected.to include 'status', 'counts' }
  end

  describe 'the counts object' do
    subject(:counts) { json['counts'] }

    let(:counts_keys) do
      %w[
        authors
        items
        ledgers
        loans
        patrons
        subjects
        works
      ]
    end

    it { is_expected.to be_a Hash }
    it { is_expected.to include(*counts_keys) }

    it 'has counts attached to each key' do
      counts_keys.each do |key|
        expect(counts[key]).to be_an Integer
      end
    end
  end
end
