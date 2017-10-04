class CreatePatrons < ActiveRecord::Migration[5.1]
  def change
    create_table :patrons do |t|
      t.string :name
      t.string :types

      t.integer :drupal_node_id
      t.string :drupal_node_type, default: 'node'
    end
  end
end
