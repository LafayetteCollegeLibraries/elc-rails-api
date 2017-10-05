class Ledger < ApplicationRecord
  include Drupal
  
  has_many :loans

  def representatives
    Patron.find(loans.map(&:representative_id).reject(&:nil?).uniq)
  end

  def shareholders
    Patron.find(loans.map(&:shareholder_id).reject(&:nil?).uniq)
  end

  # get all of the patrons listed in a ledger
  def patrons
    ids = loans.map(&:representative_id).reject(&:nil?).uniq([]) do |acc, loan|
            acc << loan[:shareholder_id]
            acc << loan[:representative_id]
          end.reject(&:nil?).uniq

    Patron.find(ids)
  end
end
