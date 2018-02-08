require 'csv'

RSpec.describe Author do
  let(:node_id) { '1234' }
  let(:author_name) { 'Author Name' }
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
    # can't use let(:author) = Author.create_from_csv_row!(row)
    # because transactions are limited per test by default
    # (see: https://relishapp.com/rspec/rspec-rails/v/3-7/docs/model-specs/transactional-examples)
    it 'persists the Author to the database' do
      created = Author.create_from_csv_row!(row)
      expect(Author.find_by(drupal_node_id: node_id)).to eq created
    end
  end

  its :types { should contain_exactly 'Author' }
  its :drupal_node_type { should eq 'node' }
end