require 'csv'

RSpec.describe Work do
  subject(:work) { build(:work) }

  its(:title) do
    is_expected.not_to include "(#{work.format} #{work.number})"
  end

  its(:full_title) { is_expected.to eq work[:title] }

  it { is_expected.to have_and_belong_to_many :authors }
  it { is_expected.to have_and_belong_to_many :subjects }
  it { is_expected.to have_many :items }
  it { is_expected.to have_many(:loans).through(:items) }

  context 'when importing from a CSV row' do
    let(:authors) { create_list(:author, 1) }
    let(:subjects) { create_list(:subject, 2) }
    let(:attrs) { attributes_for(:work) }

    let(:row) do
      CSV::Row.new(
        %w[node_id author_node_id subject_node_ids item_title format number],
        [
          attrs[:drupal_node_id],
          authors.map(&:drupal_node_id).join(';'),
          subjects.map(&:drupal_node_id).join(';'),
          attrs[:title],
          attrs[:format],
          attrs[:number]
        ]
      )
    end

    describe '.initialize_from_csv_row' do
      subject { described_class.initialize_from_csv_row(row) }

      its(:authors) { is_expected.to eq authors }
      its(:subjects) { is_expected.to eq subjects }
      its(:new_record?) { is_expected.to be true }
    end

    describe '.create_from_csv_row!' do
      subject { described_class.create_from_csv_row!(row) }

      its(:new_record?) { is_expected.to be false }
    end
  end
end
