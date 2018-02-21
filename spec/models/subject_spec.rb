require 'csv'

RSpec.describe Subject do
  its(:drupal_node_type) { is_expected.to eq 'taxonomy' }
  it { is_expected.to have_and_belong_to_many :works }

  context 'when importing from a csv row' do
    let(:attrs) { attributes_for(:subject) }
    let(:taxonomy_id) { attrs[:drupal_node_id] }
    let(:label) { attrs[:label] }
    let(:row) do
      CSV::Row.new(
        %w[taxonomy_id label],
        [taxonomy_id, label]
      )
    end

    describe '.initialize_from_csv_row' do
      subject { described_class.initialize_from_csv_row(row) }

      its(:label) { is_expected.to eq label }
      its(:drupal_node_id) { is_expected.to eq taxonomy_id.to_i }
      its(:new_record?) { is_expected.to be true }
    end

    describe '.create_from_csv_row!' do
      subject { described_class.create_from_csv_row!(row) }

      its(:new_record?) { is_expected.to be false }
    end
  end

  describe '.search' do
    let(:term) { '~!! SEARCH TERM !!~' }

    before do
      create_list(:subject, 2, label: 'Nope!')
    end

    context 'with a term that exists' do
      subject { described_class.search(term) }

      let!(:sub1) { create(:subject, label: "Subject with #{term}") }

      after { sub1.delete }

      its(:length) { is_expected.to eq 1 }
      its(:first) { is_expected.to eq sub1 }
    end

    context 'with a term that does not exist' do
      subject { described_class.search(term) }

      its(:length) { is_expected.to eq 0 }
    end
  end
end
