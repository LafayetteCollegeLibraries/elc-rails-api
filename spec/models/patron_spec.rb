require 'csv'

RSpec.describe Patron do
  it { is_expected.to have_and_belong_to_many :person_types }

  context 'when a Shareholder' do
    subject { create(:shareholder) }

    its(:shareholder?) { is_expected.to be true }
    its(:representative?) { is_expected.to be true }
  end

  context 'when a Representative' do
    subject { create(:representative) }

    its(:shareholder?) { is_expected.to be false }
    its(:representative?) { is_expected.to be true }
  end

  context 'when importing from a CSV row' do
    let(:representative) { create(:person_type, :representative) }
    let(:shareholder) { create(:person_type, :shareholder) }
    let(:row) do
      CSV::Row.new(
        %w[node_id name person_type_node_ids],
        [
          '1234',
          'Patron, V. Important',
          [representative, shareholder].map(&:drupal_node_id).join(';')
        ]
      )
    end

    describe '.initialize_from_csv_row' do
      subject { described_class.initialize_from_csv_row(row) }

      its(:person_types) { is_expected.to include representative }
      its(:person_types) { is_expected.to include shareholder }
      its(:new_record?) { is_expected.to be true }
    end

    describe '.create_from_csv_row!' do
      subject { described_class.create_from_csv_row!(row) }

      its(:new_record?) { is_expected.to be false }
    end
  end
end
