class Subject < ApplicationRecord
  include Drupal
  include Randomizable
  
  has_and_belongs_to_many :works

  scope :search, -> (query) { where("label like ?", "%#{query}%") }

  class << self
    def initialize_from_csv_row(row)
      find_or_initialize_by(
        drupal_node_id: row['taxonomy_id'].to_i,
        drupal_node_type: 'taxonomy',
        label: row['label']
      )
    end

    def create_from_csv_row!(row)
      subject = initialize_from_csv_row(row)
      subject.save!

      subject
    end
  end
end
