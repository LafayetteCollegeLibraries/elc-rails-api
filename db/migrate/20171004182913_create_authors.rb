class CreateAuthors < ActiveRecord::Migration[5.1]
  def change
    create_table :authors do |t|
      t.string :name

      t.integer :drupal_node_id
      t.string :drupal_node_type, default: 'node'
    end
  end
end
