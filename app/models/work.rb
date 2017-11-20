class Work < ApplicationRecord
  include Drupal
  include Randomizable
  
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :subjects
  has_many :items
  has_many :loans, through: :items

  scope :search, -> (query) { where("title like ?", "%#{query}%") }
  scope :by_author, -> (author) { where("author_id = ?", author) }
  scope :by_subject, -> (sub) { Subject.find(sub).works }

  def full_title
    self[:title]
  end

  # this is just a band-aid for now
  def title
    self[:title]
      .gsub('&amp;', '&')
      .gsub("(#{format} #{number})", '')
      .strip
  end

  class << self
    def initialize_from_csv_row(row)
      work = find_or_initialize_by(drupal_node_id: row['node_id'].to_i)

      return work unless work.new_record?

      author_ids = (row['author_node_id'] || '').split(';').map(&:to_i)
      subject_ids = (row['subject_node_ids'] || '').split(';').map(&:to_i)

      work.title = row['item_title']
      work.authors = Author.where(drupal_node_id: author_ids)
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
