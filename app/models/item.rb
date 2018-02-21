class Item < ApplicationRecord
  include Drupal

  belongs_to :work
  has_and_belongs_to_many :loans

  delegate :title, :full_title, :authors, :subjects, to: :work
end
