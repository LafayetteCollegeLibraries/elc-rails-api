class Subject < ApplicationRecord
  include Drupal
  
  has_and_belongs_to_many :items

  scope :search, -> (query) { where("label like ?", "%#{query}%") }
end
