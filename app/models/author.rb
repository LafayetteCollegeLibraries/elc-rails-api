class Author < ApplicationRecord
  include Drupal
  include Randomizable

  has_many :items

  scope :search, -> (query) { where("name like ?", "%#{query}%") }

  class << self
    def initialize_from_csv_row(row)
      author = find_or_initialize_by(drupal_node_id: row['node_id'].to_i)
      return author unless author.new_record?

      author.name = row['name']
      author.drupal_node_type = 'node'

      author
    end

    def create_from_csv_row!(row)
      author = initialize_from_csv_row(row)
      author.save!

      author
    end
  end
end
