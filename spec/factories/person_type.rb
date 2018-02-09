FactoryBot.define do
  factory :person_type do
    sequence :drupal_node_id
    
    trait :shareholder do
      label 'Shareholder'
    end

    trait :representative do
      label 'Representative'
    end

    trait :author do
      label 'Author'
    end
  end
end