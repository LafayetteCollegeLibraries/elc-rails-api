class Item < ApplicationRecord
  include Drupal

  belongs_to :work
end