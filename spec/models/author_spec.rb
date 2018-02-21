require 'csv'

RSpec.describe Author do
  let(:attrs) { attributes_for(:author) }
  let(:node_id) { attrs[:drupal_node_id] }
  let(:author_name) { attrs[:name] }
  let(:row) do
    CSV::Row.new(
      %w[node_id name],
      [node_id, author_name]
    )
  end

  describe '.initialize_from_csv_row' do
    subject { described_class.initialize_from_csv_row(row) }

    its(:name) { is_expected.to eq author_name }
    its(:drupal_node_id) { is_expected.to eq node_id.to_i }
    its(:new_record?) { is_expected.to be true }
  end

  describe '.create_from_csv_row!' do
    subject { described_class.create_from_csv_row!(row) }

    its(:new_record?) { is_expected.to be false }
  end

  its(:types) { is_expected.to contain_exactly 'Author' }
  its(:drupal_node_type) { is_expected.to eq 'node' }

  it { is_expected.to have_and_belong_to_many :works }
end
