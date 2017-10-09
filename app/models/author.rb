class Author < ApplicationRecord
  has_many :items

  scope :search, -> (query) { where("name like ?", "%#{query}%") }
end
