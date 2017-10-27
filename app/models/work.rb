class Work < ApplicationRecord
  include Drupal
  include Randomizable
  
  belongs_to :author, optional: true
  has_and_belongs_to_many :subjects

  scope :search, -> (query) { where("title like ?", "%#{query}%") }

  # def loan_history
  #   Loan.for_item(id)
  # end

  # this is just a band-aid for now
  def title
    self[:title]
      .gsub('&amp;', '&')
      .gsub("(#{format} #{number})", '')
      .strip
  end

  def full_title
    self[:title]
  end

  class << self
    def initialize_from_csv_row(row)
      work = find_or_initialize_by(drupal_node_id: row['node_id'].to_i)

      return work unless work.new_record?

      author_id = row['author_node_id'].to_i
      subject_ids = (row['subject_node_ids'] || '').split(';')

      work.title = row['item_title']
      work.author = Author.find_by_drupal_id(author_id)
      work.subjects = Subject.where(drupal_node_id: subject_ids)

      work.format = row['format']
      work.number = row['number']

      work
    end

    def create_from_csv_row!(row)
      work = initialize_from_csv_row(row)
      work.save! # if work.new_record?

      work
    end
  end
end
