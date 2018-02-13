require 'csv'

RSpec.describe Subject do
  its(:drupal_node_type) { should eq 'taxonomy' }
  it { should have_and_belong_to_many :works }

  context 'when importing from a csv row' do
    let(:attrs) { attributes_for(:subject) }
    let(:taxonomy_id) { attrs[:drupal_node_id] }
    let(:label) { attrs[:label] }
    let(:row) do
      CSV::Row.new(
        ['taxonomy_id', 'label'],
        [taxonomy_id, label]
      )
    end

    describe '.initialize_from_csv_row' do
      subject { Subject.initialize_from_csv_row(row) }

      its(:label) { should eq label }
      its(:drupal_node_id) { should eq taxonomy_id.to_i }
      its(:new_record?) { should be true }
    end

    describe '.create_from_csv_row!' do
      subject { Subject.create_from_csv_row!(row) }
      its(:new_record?) { should be false }
    end
  end

  describe '.search' do
    context 'with a term that exists' do
      before :context do
        term = 'SEARCH TERM'
        @sub1 = create(:subject, label: "Subject with #{term}")
        @sub2 = create(:subject, label: "Not here")
        @results = Subject.search(term)
      end

      after :context do
        @sub1.delete
        @sub2.delete
      end

      subject { @results }

      its(:count) { should eq 1 }
      its(:first) { should eq @sub1 }
    end

    context 'with a term that does not exist' do
      before :context do
        term = 'SEARCH TERM'
        @sub1 = create(:subject, label: 'Not here')
        @sub2 = create(:subject, label: 'Not here, either')
        @results = Subject.search(term)
      end

      after :context do
        @sub1.delete
        @sub2.delete
      end

      subject { @results }

      its(:count) { should eq 0 }
    end
  end
end