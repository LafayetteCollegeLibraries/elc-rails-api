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
    return self[:label] if representative.blank?

    "#{representative.name} borrowed \"#{item.title}\" on #{checkout_date.strftime('%A, %B %-d, %Y')}"
  end


  def return_date=(date)
    super(ensure_datetime(date))
  end
  
  def self.random
    self.find(self.random_id)
  end

  def self.random_id
    rand(self.count)
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
