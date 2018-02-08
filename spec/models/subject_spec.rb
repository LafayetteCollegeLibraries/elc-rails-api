require 'csv'

RSpec.describe Subject do
  let(:taxonomy_id) { 10 }
  let(:label) { 'Subject Label' }
  let(:row) do
    CSV::Row.new(
      ['taxonomy_id', 'label'],
      [taxonomy_id, label]
    )
  end

  describe '.initialize_from_csv_row' do
    subject { Subject.initialize_from_csv_row(row) }

    its(:label) { should eq label }
    its(:drupal_node_id) { should eq taxonomy_id.to_i }
    its(:new_record?) { should be true }
  end

  describe '.create_from_csv_row!' do
    subject { Subject.create_from_csv_row!(row) }
    its(:new_record?) { should be false }
  end

  its(:drupal_node_type) { should eq 'taxonomy' }
end