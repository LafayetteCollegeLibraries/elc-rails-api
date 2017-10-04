class CreateItemsSubjectsJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_table :items_subjects, id: false do |t|
      t.integer :item_id
      t.integer :subject_id
    end

    add_index :items_subjects, :item_id
    add_index :items_subjects, :subject_id
  end
end
