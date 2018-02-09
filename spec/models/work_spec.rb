require 'csv'

RSpec.describe Work do
  context 'when importing from a CSV row' do
    let(:authors) { create_list(:author, 1) }
    let(:subjects) { create_list(:subject, 2) }
    let(:attrs) { attributes_for(:work) }

    let(:row) do
      CSV::Row.new(
        %w(node_id author_node_id subject_node_ids item_title format number),
        [
          attrs[:drupal_node_id],
          authors.map(&:drupal_node_id).join(';'),
          subjects.map(&:drupal_node_id).join(';'),
          attrs[:title],
          attrs[:format],
          attrs[:number]
        ]
      )
    end

    describe '.initialize_from_csv_row' do
      subject { Work.initialize_from_csv_row(row) }

      its(:authors) { should eq authors }
      its(:subjects) { should eq subjects }
      its(:new_record?) { should be true }
    end

    describe '.create_from_csv_row!' do
      subject { Work.create_from_csv_row!(row) }
      its(:new_record?) { should be false }
    end
  end

  subject { build(:work) }

  its(:title) { should_not include "(#{subject.format} #{subject.number})" }
  its(:full_title) { should eq subject[:title] }
end