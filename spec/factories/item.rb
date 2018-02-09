FactoryBot.define do
  factory :item do
    work { create(:work) }

    factory :item_with_issue do
      sequence :issue { |n| ((n + 1) % 200).to_s }
    end

    factory :item_with_year do
      sequence :year { |n| ((n % 200) + 1600).to_s }
    end

    factory :item_with_volume do
      sequence :volume { |n| "v#{(n + 1) % 10}"}
    end
  end
end