require 'csv'

RSpec.describe Author do
  let(:attrs) { attributes_for(:author) }
  let(:node_id) { attrs[:drupal_node_id] }
  let(:author_name) { attrs[:name] }
  let(:row) do
    CSV::Row.new(
      ['node_id', 'name'],
      [node_id, author_name]
    )
  end

  describe '.initialize_from_csv_row' do
    subject { Author.initialize_from_csv_row(row) }

    its(:name) { should eq author_name }
    its(:drupal_node_id) { should eq node_id.to_i }
    its(:new_record?) { should be true }
  end

  describe '.create_from_csv_row!' do
    subject { Author.create_from_csv_row!(row) }
    its(:new_record?) { should be false }
  end

  its :types { should contain_exactly 'Author' }
  its :drupal_node_type { should eq 'node' }
end