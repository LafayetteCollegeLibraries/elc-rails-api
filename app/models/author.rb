class Author < ApplicationRecord
  include Drupal

  attribute :drupal_node_type, :string, default: 'node'

  has_and_belongs_to_many :works

  scope :search, ->(query) { where('name like ?', "%#{query}%") }

  def types
    ['Author']
  end

  class << self
    def initialize_from_csv_row(row)
      author = find_or_initialize_by(drupal_node_id: row['node_id'].to_i)
      return author unless author.new_record?

      author.tap do |a|
        a.name = row['name']
      end
    end

    def create_from_csv_row!(row)
      author = initialize_from_csv_row(row)
      author.save!

      author
    end
  end
end
