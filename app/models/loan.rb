require 'date'

class Loan < ApplicationRecord
  include Drupal

  belongs_to :shareholder, class_name: 'Patron', optional: true
  belongs_to :representative, class_name: 'Patron', optional: true
  belongs_to :item
  belongs_to :ledger

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

  # convenience searchers
  class << self
    def for_item(item)
      where(item: item)
    end

    def for_patron(person)
      where(representative: person).or(where(shareholder: person))
    end

    def for_representative(person)
      where(representative: person)
    end

    def for_shareholder(person)
      where(shareholder: person)
    end

    def random
      find(random_id)
    end
  
    def random_id
      rand(count)
    end
  end

  private
    # TODO more thorough checking?
    def ensure_datetime(date)
      return date if date.is_a? DateTime

      if date.is_a? String      
        month, day, year = date.split('/').map(&:to_i)
        DateTime.new(year, month, day)
      end
    end
end
