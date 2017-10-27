class AddCsvLineToLoans < ActiveRecord::Migration[5.1]
  def change
    # "loans-ledger-1:100"
    add_column :loans, :csv_source, :string
  end
end
