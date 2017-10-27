class CreateItemsAgain < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.belongs_to :work, index: true

      t.string :drupal_node_type, default: 'node'
      t.integer :drupal_node_id

      t.timestamps

      # NOTE: these are delimited strings that are
      # split into arrays when their objects are created
      t.string :volume
      t.string :year
      t.string :issue
    end
  end
end
