class Ledger < ApplicationRecord
  include Drupal
  
  has_many :loans
end
