class DropItemIdFromLoan < ActiveRecord::Migration[5.1]
  def change
    remove_column :loans, :item_id, :integer
  end
end
