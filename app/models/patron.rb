class Patron < ApplicationRecord
  include Drupal

  has_and_belongs_to_many :person_types

  scope :search, -> (query) { where("name like ?", "%#{query}%") }

  def loans
    Loan.for_patron(id)
  end

  def representative?
    types.include? 'Representative'
  end

  def shareholder?
    types.include? 'Shareholder'
  end

  def types
    person_types.map(&:label)
  end

  class << self
    def initialize_from_csv_row(row)
      patron = find_or_initialize_by(drupal_node_id: row['node_id'].to_i)
      return patron unless patron.new_record?

      type_node_ids = row['person_type_node_ids']

      patron.name = row['name']
      patron.drupal_node_type = 'node'

      return patron unless type_node_ids

      patron.person_types = type_node_ids.split(/[,;]\s?/)
                            .map { |id| PersonType.find_by(drupal_node_id: id) }
                            .reject(&:blank?)
      patron
    end

    def create_from_csv_row!(row)
      patron = initialize_from_csv_row(row)
      patron.save! if patron.new_record?

      patron
    end
  end
end
