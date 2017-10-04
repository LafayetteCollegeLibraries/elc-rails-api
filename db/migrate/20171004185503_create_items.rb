class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.belongs_to :author, index: true

      t.string :title
  
      t.string :format
      t.integer :number

      t.string :drupal_node_type, default: 'node'
      t.integer :drupal_node_id
    end
  end
end
