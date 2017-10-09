class Item < ApplicationRecord
  include Drupal
  
  belongs_to :author, optional: true
  has_and_belongs_to_many :subjects

  scope :search, -> (query) { where("title like ?", "%#{query}%") }

  def loan_history
    Loan.for_item(id)
  end

  # this is just a band-aid for now
  def title
    self[:title].gsub('&amp;', '&')
  end
end
