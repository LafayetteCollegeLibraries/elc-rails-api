class PersonType < ApplicationRecord
  has_and_belongs_to_many :patrons
end
