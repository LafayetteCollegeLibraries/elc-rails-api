class Work < ApplicationRecord
  include Drupal

  has_and_belongs_to_many :authors
  has_and_belongs_to_many :subjects
  has_many :items, dependent: :nullify
  has_many :loans, through: :items

  scope :search, ->(query) { where('title like ?', "%#{query}%") }

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
    def by_author(author)
      joins(:authors).where('author_id = ?', [author])
    end

    def by_subject(subject)
      joins(:subjects).where('subject_id = ?', [subject])
    end

    def initialize_from_csv_row(row)
      work = find_or_initialize_by(drupal_node_id: row['node_id'].to_i)

      return work unless work.new_record?

      work.title = row['item_title']
      work.authors = authors_by_ids(row['author_node_id'])
      work.subjects = subjects_by_ids(row['subject_node_ids'])

      work.format = row['format']
      work.number = row['number']

      work
    end

    def create_from_csv_row!(row)
      work = initialize_from_csv_row(row)
      work.save! # if work.new_record?

      work
    end

    private

    def authors_by_ids(col)
      return [] unless col
      Author.where(drupal_node_id: col.split(';').map(&:to_i))
    end

    def subjects_by_ids(col)
      return [] unless col
      Subject.where(drupal_node_id: col.split(';').map(&:to_i))
    end
  end
end
