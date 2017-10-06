class Ledger < ApplicationRecord
  include Drupal
  
  has_many :loans

  # s/o to https://stackoverflow.com/a/5846672
  has_many :representatives, -> { distinct }, through: :loans
  has_many :shareholders, -> { distinct }, through: :loans

  def files
    loans.map {|l| l.ledger_filename }.uniq.sort
  end

  # get all of the patrons listed in a ledger
  def patrons
    [representatives, shareholders].flatten.uniq.sort
  end
end
