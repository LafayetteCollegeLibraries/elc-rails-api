class Patron < ApplicationRecord
  include Drupal

  has_and_belongs_to_many :person_types

  scope :search, -> (query) { where("name like ?", "%#{query}%") }

  def loans
    Loan.for_patron(id)
  end

  def representative?
    types.include? 'Representative'
  end

  def shareholder?
    types.include? 'Shareholder'
  end

  def types
    self.person_types.map(&:label)
  end
end
