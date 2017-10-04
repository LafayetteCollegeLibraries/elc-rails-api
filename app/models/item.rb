class Item < ApplicationRecord
  belongs_to :author, optional: true
  has_and_belongs_to_many :subjects
end
