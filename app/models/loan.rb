require 'date'

class Loan < ApplicationRecord
  include Drupal
  include Randomizable

  belongs_to :shareholder, class_name: 'Patron', optional: true
  belongs_to :representative, class_name: 'Patron', optional: true
  belongs_to :item
  belongs_to :ledger

  scope :for_checkout_date, ->(date) { where(checkout_date: date) }
  scope :for_item, ->(item) { where(item: item) }
  scope :for_patron, ->(person) { where(representative: person).or(where(shareholder: person)) }
  scope :for_representative, -> (person) { where(representative: person) }
  scope :for_shareholder, -> (person) { where(shareholder: person) }

  def checkout_date=(date)
    super(ensure_datetime(date))
  end

  def label
    "#{loaned_to} borrowed \"#{item.title}\" on #{checkout_date.strftime('%A, %B %-d, %Y')}"
  end

  def loaned_to
    if representative.present?
      representative.name
    elsif shareholder.present?
      shareholder.name
    else
      '???'
    end
  end

  def return_date=(date)
    super(ensure_datetime(date))
  end
  
  def view_ledger_url
    "https://elc.lafayette.edu/collections/eastonlibrary/#{ledger_filename}"
  end

  def issues
    (self[:issues] || '').split(/[;,]\s?/)
  end

  def volumes
    (self[:volumes] || '').split(/[;,]\s?/)
  end

  def years
    (self[:years] || '').split(/[;,]\s?/)
  end

  class << self
    def initialize_from_csv_row(row)
      loan = find_or_initialize_by(drupal_node_id: row['node_id'].to_i)
      return loan unless loan.new_record?

      loan.label = row['label']
      loan.drupal_node_type = 'taxonomy'

      loan
    end

    def create_from_csv_row!(row)
      loan = initialize_from_csv_row(row)
      loan.save!

      loan
    end
  end

  private
    # TODO more thorough checking?
    def ensure_datetime(date)
      return date if date.is_a? DateTime

      if date.is_a? String      
        month, day, year = date.split(/[\/\-]/).map(&:to_i)
        DateTime.new(year, month, day)
      end
    end
end
