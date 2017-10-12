class Item < ApplicationRecord
  include Drupal
  include Randomizable
  
  belongs_to :author, optional: true
  has_and_belongs_to_many :subjects

  scope :search, -> (query) { where("title like ?", "%#{query}%") }

  def loan_history
    Loan.for_item(id)
  end

  # this is just a band-aid for now
  def title
    self[:title].gsub('&amp;', '&')
  end

  class << self
    def initialize_from_csv_row(row)
      item = find_or_initialize_by(drupal_node_id: row['node_id'].to_i)
      return item unless item.new_record?

      author_id = row['author_node_id'].to_i
      title_node_id = row['title_node_id'].to_i
      
      item.title = row['item_title']
    end

    def create_from_csv_row!(row)
      item = initialize_from_csv_row!(row)
      item.save! if item.new_record?

      item
    end
  end
end
