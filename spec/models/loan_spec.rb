require 'date'

RSpec.describe Loan do
  it { is_expected.to belong_to(:shareholder).class_name('Patron') }
  it { is_expected.to belong_to(:representative).class_name('Patron') }
  it { is_expected.to belong_to(:ledger) }
  it { is_expected.to have_and_belong_to_many :items }

  describe '#checkout_date=' do
    let(:datetime) { DateTime.new(1886, 2, 11) }

    context 'when passed a DateTime' do
      subject { create(:loan, checkout_date: datetime) }

      its(:checkout_date) { is_expected.to eq datetime }
    end

    context 'when passed a M(M)/D(D)/YYYY string' do
      subject { create(:loan, checkout_date: datestr) }

      let(:datestr) { datetime.strftime('%m/%d/%Y') }

      its(:checkout_date) { is_expected.to eq datetime }
    end
  end

  describe '#issued_borrowed' do
    context 'when items with issues are present' do
      subject { create(:loan, with_issues: true) }

      its(:issues_borrowed) { is_expected.not_to be_empty }
    end

    context 'when items with issues are not present' do
      subject { create(:loan, with_issues: false) }

      its(:issues_borrowed) { is_expected.to be_empty }
    end
  end

  describe '#label' do
    subject(:loan) { create(:loan) }

    its(:label) { is_expected.to include loan.work.title }
    its(:label) { is_expected.to include loan.loaned_to }
  end

  describe '#loaned_to' do
    context 'when a representative is present' do
      subject { create(:loan, representative: representative) }

      let(:representative) { create(:representative) }

      its(:loaned_to) { is_expected.to eq representative.name }
    end

    context 'when a shareholder is present but not a representative' do
      subject { create(:loan, representative: nil, shareholder: shareholder) }

      let(:shareholder) { create(:shareholder) }

      its(:loaned_to) { is_expected.to eq shareholder.name }
    end

    context 'when neither is provided "???" is returned' do
      subject { create(:loan, representative: nil, shareholder: nil) }

      its(:loaned_to) { is_expected.to eq '???' }
    end
  end

  describe '#return_date=' do
    let(:datetime) { DateTime.new(1886, 2, 25) }

    context 'when passed a DateTime' do
      subject { create(:loan, return_date: datetime) }

      its(:return_date) { is_expected.to eq datetime }
    end

    context 'when passed a M(M)/D(D)/YYYY string' do
      subject { create(:loan, return_date: datestr) }

      let(:datestr) { datetime.strftime('%m/%d/%Y') }

      its(:return_date) { is_expected.to eq datetime }
    end
  end

  describe '#view_ledger_url' do
    subject { created }

    let(:created) { create(:loan) }

    its(:view_ledger_url) { is_expected.to include created.ledger_filename }
  end

  describe '#volumes_borrowed' do
    context 'when items with volumes are present' do
      subject { create(:loan, with_volumes: true) }

      its(:volumes_borrowed) { is_expected.not_to be_empty }
    end

    context 'when items with volume are not present' do
      subject { create(:loan, with_volumes: false) }

      its(:volumes_borrowed) { is_expected.to be_empty }
    end
  end

  describe '#work' do
    let(:created) { create(:loan, number_of_items: 3) }
    let(:filtered) { created.items.map(&:work).uniq }

    it 'is_expected.to display the Work associated with loaned Items' do
      raise 'Loan has more than one Work' if filtered.count != 1

      expect(created.work).to eq(filtered.first)
    end
  end

  describe '#years_borrowed' do
    context 'when items with years are present' do
      subject { create(:loan, with_years: true) }

      its(:years_borrowed) { is_expected.not_to be_empty }
    end

    context 'when items with years are not present' do
      subject { create(:loan, with_years: false) }

      its(:years_borrowed) { is_expected.to be_empty }
    end
  end
end
