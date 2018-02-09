require 'date'

class Loan < ApplicationRecord
  include Drupal
  include Randomizable

  scope :for_checkout_date, -> (date) { where(checkout_date: date) }
  scope :for_item, -> (item) { where(item: item) }
  scope :for_representative, -> (person) { where(representative: person) }
  scope :for_shareholder, -> (person) { where(shareholder: person) }
  scope :for_patron, -> (patron) { where(shareholder: patron).or(where(representative: patron)) }
  scope :for_patron_on_date, -> (patron, date) { where('representative_id = ? AND checkout_date = ?', patron, date) }

  # this one is a bit tough because of the many-to-one relationship of
  # items to works and the many-to-one relationship of items to loans.
  # this may be an optimization to-do down the road, but for now It Works.
  scope :for_work, -> (work) { work.loans }

  belongs_to :shareholder, class_name: 'Patron', optional: true
  belongs_to :representative, class_name: 'Patron', optional: true
  belongs_to :ledger
  has_and_belongs_to_many :items

  def checkout_date=(date)
    super(ensure_datetime(date))
  end

  def issues_borrowed
    items.map(&:issue).reject(&:blank?)
  end

  def volumes_borrowed
    items.map(&:volume).reject(&:blank?)
  end

  def years_borrowed
    items.map(&:year).reject(&:blank?)
  end

  def label
    "#{loaned_to} borrowed \"#{work.title}\" on #{checkout_date.strftime('%A, %B %-d, %Y')}"
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

  def work
    items.first.work
  end

  # TODO: extract a bunch of the work being done on the ingest script
  # and perform it in these method (ex. assigning works + patrons)
  # class << self
    # def initialize_from_csv_row(row)
    # end

    # def create_from_csv_row!(row)
    # end
  # end

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
