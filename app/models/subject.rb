class Subject < ApplicationRecord
  include Drupal
  include Randomizable
  
  has_and_belongs_to_many :items

  scope :search, -> (query) { where("label like ?", "%#{query}%") }

  class << self
    def initialize_from_csv_row(row)
      subject = find_or_initialize_by(drupal_node_id: row['node_id'].to_i)
      return subject unless subject.new_record?

      subject.label = row['label']
      subject.drupal_node_type = 'taxonomy'

      subject
    end

    def create_from_csv_row!(row)
      subject = initialize_from_csv_row(row)
      subject.save!

      subject
    end
  end
end
