class AddPersonTypeToPatrons < ActiveRecord::Migration[5.1]
  def change
    remove_column :patrons, :types

    create_table :patrons_person_types, id: false do |t|
      t.integer :patron_id
      t.integer :person_type_id
    end

    add_index :patrons_person_types, :patron_id
    add_index :patrons_person_types, :person_type_id
  end
end
