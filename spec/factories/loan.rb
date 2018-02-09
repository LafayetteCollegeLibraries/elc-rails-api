require 'date'

FactoryBot.define do
  factory :loan do
    transient do
      number_of_items 1
      with_issues false
      with_volumes false
      with_years false
    end

    representative { create(:representative) }
    shareholder { create(:shareholder) }
    checkout_date DateTime.new(1820, 1, 1)
    return_date DateTime.new(1820, 1, 21)
    ledger_filename 'ELCv0000'

    # TODO: create a propery factory
    ledger { Ledger.create }

    after(:create) do |loan, evaluator|
      which = if evaluator.with_issues
                :item_with_issue
              elsif evaluator.with_volumes
                :item_with_volume
              elsif evaluator.with_years
                :item_with_year
              else
                :item
              end

      create_list(which, evaluator.number_of_items, loans: [loan], work: create(:work))
    end
  end
end