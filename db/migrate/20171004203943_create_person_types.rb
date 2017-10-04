class CreatePersonTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :person_types do |t|
      t.string :label
      
      t.string :drupal_node_type, default: 'taxonomy'
      t.integer :drupal_node_id
    end
  end
end
