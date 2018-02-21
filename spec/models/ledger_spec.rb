RSpec.describe Ledger do
  it { is_expected.to have_many :loans }
  it { is_expected.to have_many(:representatives).through(:loans) }
  it { is_expected.to have_many(:shareholders).through(:loans) }

  describe '#files' do
    subject { ledger.files }

    let(:ledger) { described_class.new(loans: loans) }
    let(:loans) do
      [
        build_list(:loan, 3, ledger_filename: 'ELCv0001'),
        build_list(:loan, 3, ledger_filename: 'ELCv0002'),
        build_list(:loan, 3, ledger_filename: 'ELCv0003')
      ].flatten
    end

    it { is_expected.to be_an Array }
    its(:length) { is_expected.to be < loans.length }
    its(:length) { is_expected.to eq 3 }
  end
end
