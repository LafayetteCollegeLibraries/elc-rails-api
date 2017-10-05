class Subject < ApplicationRecord
  include Drupal
  
  has_and_belongs_to_many :items
end
