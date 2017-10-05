# volumes
# issues
# years
class CreateLoans < ActiveRecord::Migration[5.1]
  def change
    create_table :loans do |t|
      t.string :label # inferrable and not necessary?
      t.belongs_to :item

      t.datetime :checkout_date
      t.datetime :return_date

      t.string :ledger_filename

      t.references :shareholder
      t.references :representative

      t.string :drupal_node_type, default: 'node'
      t.integer :drupal_node_id
    end
  end
end
