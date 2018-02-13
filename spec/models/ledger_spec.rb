RSpec.describe Ledger do
  it { should have_many :loans }
  it { should have_many(:representatives).through(:loans) }
  it { should have_many(:shareholders).through(:loans) }

  describe '#files' do
    before :all do
      @loans = [
        build_list(:loan, 3, ledger_filename: 'ELCv0001'),
        build_list(:loan, 3, ledger_filename: 'ELCv0002'),
        build_list(:loan, 3, ledger_filename: 'ELCv0003')
      ].flatten

      @ledger = Ledger.new(loans: @loans)
    end

    subject { @ledger.files }

    it { should be_an Array }
    its(:length) { should be < @loans.length }
    its(:length) { should eq 3 }
  end
end