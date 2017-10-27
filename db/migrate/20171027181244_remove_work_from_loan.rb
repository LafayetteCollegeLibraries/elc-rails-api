class RemoveWorkFromLoan < ActiveRecord::Migration[5.1]
  def change
    remove_column :loans, :work_id, :integer
  end
end
