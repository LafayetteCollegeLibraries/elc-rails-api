FactoryBot.define do
  factory :patron do
    name 'Test Patron'
    sequence :drupal_node_id

    factory :shareholder do
      person_types do 
        [
          create(:person_type, :shareholder),
          create(:person_type, :representative)
        ]
      end
    end

    factory :representative do
      person_types { [create(:person_type, :representative)] }
    end
  end
end