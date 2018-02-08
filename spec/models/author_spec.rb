require 'rails_helper'
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
    let(:author) { Author.initialize_from_csv_row(row) }

    it 'adds the value from the `name` field' do
      expect(author.name).to eq author_name
    end

    it 'sets the `node_id` to :drupal_node_id' do
      expect(author.drupal_node_id).to eq node_id.to_i
    end

    it 'assigns the :drupal_node_type of `node`' do
      expect(author.drupal_node_type).to eq 'node'
    end

    it 'does not persist the Author to the database' do
      expect(author.new_record?).to be true
    end
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

  describe '#types' do
    it 'contains only "Author"' do
      expect(Author.initialize_from_csv_row(row).types).to contain_exactly('Author')
    end
  end
end