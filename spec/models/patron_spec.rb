require 'csv'

RSpec.describe Patron do
  context 'when a Shareholder' do
    subject { create(:shareholder) }

    its(:shareholder?) { should be true }
    its(:representative?) { should be true }
  end

  context 'when a Representative' do
    subject { create(:representative) }

    its(:shareholder?) { should be false }
    its(:representative?) { should be true }
  end

  context 'when importing from a CSV row' do
    describe '.initialize_from_csv_row' do
      it 'has tricky person_types association problems'
    end

    describe '.create_from_csv_row!' do
      it 'has tricky person_types association problems'
    end
  end

  it { should have_and_belong_to_many :person_types }
end