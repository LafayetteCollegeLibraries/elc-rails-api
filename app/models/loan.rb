class Loan < ApplicationRecord
  belongs_to :shareholder, class_name: 'Patron'
  belongs_to :representative, class_name: 'Patron'
  belongs_to :item
end
