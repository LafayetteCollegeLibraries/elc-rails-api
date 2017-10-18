class AddItemDetailsToLoan < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :volumes, :string
    add_column :loans, :issues, :string
    add_column :loans, :years, :string
  end
end
