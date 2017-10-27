class ChangeItemsToWorks < ActiveRecord::Migration[5.1]
  def change
    rename_table :items, :works
    remove_column :works, :drupal_title_node_id, :integer
    
    remove_index :items_subjects, :item_id
    remove_index :items_subjects, :subject_id
    rename_table :items_subjects, :subjects_works

    rename_column :subjects_works, :item_id, :work_id
    add_index :subjects_works, :work_id
    add_index :subjects_works, :subject_id

    rename_column :loans, :item_id, :work_id
  end
end
