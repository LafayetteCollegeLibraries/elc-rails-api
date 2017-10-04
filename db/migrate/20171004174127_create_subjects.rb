class CreateSubjects < ActiveRecord::Migration[5.1]
  def change
    create_table :subjects do |t|
      t.string :label

      t.integer :drupal_node_id
      t.string :drupal_node_type, default: 'taxonomy'
    end
  end
end
