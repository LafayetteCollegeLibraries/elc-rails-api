class AddLedgersLoanAssociation < ActiveRecord::Migration[5.1]
  def change
    change_table :loans do |t|
      t.belongs_to :ledger
    end
  end
end
