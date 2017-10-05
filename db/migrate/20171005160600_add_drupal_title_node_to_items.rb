class AddDrupalTitleNodeToItems < ActiveRecord::Migration[5.1]
  def change
    add_column(:items, :drupal_title_node_id, :integer)
  end
end
