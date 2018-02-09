require 'date'

RSpec.describe Loan do
  it { should belong_to(:shareholder).class_name('Patron') }
  it { should belong_to(:representative).class_name('Patron') }
  it { should belong_to(:ledger) }
  it { should have_and_belong_to_many :items }

  describe '#checkout_date=' do
    let(:datetime) { DateTime.new(1886, 2, 11) }
    
    context 'when passed a DateTime' do
      subject { create(:loan, checkout_date: datetime) }
      its(:checkout_date) { should eq datetime }
    end

    context 'when passed a M(M)/D(D)/YYYY string' do
      let(:datestr) { datetime.strftime('%m/%d/%Y') }
      subject { create(:loan, checkout_date: datestr) }
      its(:checkout_date) { should eq datetime }
    end
  end

  describe '#issued_borrowed' do
    context 'when items with issues are present' do
      subject { create(:loan, with_issues: true) }
      its(:issues_borrowed) { should_not be_empty }
    end

    context 'when items with issues are not present' do
      subject { create(:loan, with_issues: false) }
      its(:issues_borrowed) { should be_empty }
    end
  end

  describe '#label' do
    let(:created) { create(:loan) }
    subject { created }

    its(:label) { should include created.work.title }
    its(:label) { should include created.loaned_to }
  end

  describe '#loaned_to' do
    context 'when a representative is present' do
      let(:representative) { create(:representative) }
      subject { create(:loan, representative: representative) }

      its(:loaned_to) { should eq representative.name }
    end

    context 'when a shareholder is present but not a representative' do
      let(:shareholder) { create(:shareholder) }
      subject { create(:loan, representative: nil, shareholder: shareholder) }

      its(:loaned_to) { should eq shareholder.name }
    end

    context 'when neither is provided "???" is returned' do
      subject { create(:loan, representative: nil, shareholder: nil) }
      its(:loaned_to) { should eq '???' }
    end
  end

  describe '#return_date=' do
    let(:datetime) { DateTime.new(1886, 2, 25) }

    context 'when passed a DateTime' do
      subject { create(:loan, return_date: datetime) }
      its(:return_date) { should eq datetime }
    end

    context 'when passed a M(M)/D(D)/YYYY string' do
      let(:datestr) { datetime.strftime('%m/%d/%Y') }
      subject { create(:loan, return_date: datestr) }
      its(:return_date) { should eq datetime }
    end
  end

  describe '#view_ledger_url' do
    let(:created) { create(:loan) }
    subject { created }

    its(:view_ledger_url) { should include created.ledger_filename }
  end

  describe '#volumes_borrowed' do
    context 'when items with volumes are present' do
      subject { create(:loan, with_volumes: true) }
      its(:volumes_borrowed) { should_not be_empty }
    end

    context 'when items with volume are not present' do
      subject { create(:loan, with_volumes: false) }
      its(:volumes_borrowed) { should be_empty }
    end
  end

  describe '#work' do
    let(:created) { create(:loan, number_of_items: 3) }
    let(:filtered) { created.items.map(&:work).uniq }

    it 'should display the Work associated with loaned Items' do
      fail('Loan has more than one Work associated with it') if filtered.count != 1
      
      expect(created.work).to eq(filtered.first)
    end
  end

  describe '#years_borrowed' do
    context 'when items with years are present' do
      subject { create(:loan, with_years: true) }
      its(:years_borrowed) { should_not be_empty }
    end

    context 'when items with years are not present' do
      subject { create(:loan, with_years: false) } 
      its(:years_borrowed) { should be_empty }
    end
  end
end