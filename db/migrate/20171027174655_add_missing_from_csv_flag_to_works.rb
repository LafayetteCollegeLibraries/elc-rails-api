class AddMissingFromCsvFlagToWorks < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :missing_from_csv, :boolean, default: false
  end
end
