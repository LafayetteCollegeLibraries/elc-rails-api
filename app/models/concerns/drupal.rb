module Drupal
  extend ActiveSupport::Concern

  def drupal_url
    "https://elc.lafayette.edu/#{drupal_url_path}/#{drupal_node_id}"
  end

  module ClassMethods
    def find_by_drupal_id(id)
      find_by(drupal_node_id: id)
    end
  end

  private

  def drupal_url_path
    case drupal_node_type
    when 'node' then 'node'
    when 'taxonomy' then 'taxonomy/term'
    end
  end
end
