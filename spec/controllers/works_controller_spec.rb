RSpec.describe WorksController do
  let(:authors) { create_list(:author, 2) }
  let(:subjects) { create_list(:subject, 2) }

  before do
    Work.delete_all

    create(:work)

    authors.each { |author| create(:work, authors: [author]) }
    subjects.each { |subject| create(:work, subjects: [subject]) }
  end

  describe '#index' do
    context 'when no ids are passed' do
      before do
        get :index
      end

      subject { json['data'] }

      its(:length) { is_expected.to eq 5 }
    end

    context 'when :author_id provided' do
      before do
        get :index, params: { author_id: authors.first.id }
      end

      subject { json['data'] }

      its(:length) { is_expected.to eq 1 }
    end

    context 'when :subject_id provided' do
      before do
        get :index, params: { subject_id: subjects.first.id }
      end

      subject { json['data'] }

      its(:length) { is_expected.to eq 1 }
    end
  end

  describe '#show' do
    subject { json }

    let(:work) { create(:work) }
    let(:fields) do
      %w[
        authors
        format
        id
        number
        subjects
        title
      ]
    end

    before do
      get :show, params: { id: work.id }
    end

    it { is_expected.to be_a Hash }
    it { is_expected.to include(*fields) }
    it { is_expected.not_to include 'drupal_node_id', 'drupal_node_type' }
  end
end
