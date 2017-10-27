class AddItemLoanJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_table :items_loans, id: false do |t|
      t.integer :item_id
      t.integer :loan_id
    end

    add_index :items_loans, :item_id
    add_index :items_loans, :loan_id
  end
end
