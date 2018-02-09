FactoryBot.define do
  factory :work do
    format 'Duodecimo'
    sequence :number
    title { "An Imporant Work (#{format} #{number})" }
    sequence :drupal_node_id
    missing_from_csv false

    factory :work_with_subjects do
      transient do
        subject_count 2
      end

      after(:create) do |work, evaluator|
        create_list(:subject, evaluator.subject_count, works: [work])
      end
    end

    factory :work_with_authors do
      transient do
        author_count 1
      end

      after(:create) do |work, evaluator|
        create_list(:author, evaluator.author_count, works: [work])
      end
    end
  end
end