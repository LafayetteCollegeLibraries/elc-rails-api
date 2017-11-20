class WorksCanHaveMultipleAuthors < ActiveRecord::Migration[5.1]
  def change
    remove_column :works, :author_id, :integer

    create_join_table :authors, :works do |t|
      t.index [:author_id, :work_id]
      t.index [:work_id, :author_id]
    end
  end
end
