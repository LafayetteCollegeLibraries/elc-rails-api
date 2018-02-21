RSpec.describe SubjectsController do
  describe 'GET #index' do
    before do
      get :index
    end

    describe 'response.body' do
      subject { json }

      it { is_expected.to include 'data', 'meta' }
    end

    describe "response.body['data']" do
      subject { json['data'] }

      it { is_expected.to be_an Array }
    end

    describe "response.body['meta']" do
      subject { json['meta'] }

      it { is_expected.to be_a Hash }
      it { is_expected.to include 'total', 'page', 'per_page', 'total_pages' }
    end
  end

  describe 'GET #search' do
    let(:term) { 'SEARCH TERM' }
    let(:label) { "Here it is: [#{term}]" }

    before do
      create(:subject, label: label)
      create_list(:subject, 20)

      get :search, params: { q: term }
    end

    after do
      Subject.delete_all
    end

    describe 'response.body' do
      subject { json }

      it { is_expected.to include 'data', 'meta' }
    end

    describe "response.body['data']" do
      subject { json['data'] }

      it { is_expected.not_to be_empty }
      its(:length) { is_expected.to eq 1 }
    end
  end

  describe 'GET #show' do
    let(:target) { create(:subject, label: 'Cool Subject') }

    before do
      get :show, params: { id: target.id }
    end

    describe 'its payload object' do
      subject { json }

      it { is_expected.to be_a Hash }
      it { is_expected.to include 'label', 'id' }
      it { is_expected.not_to include 'drupal_node_id', 'drupal_node_type' }
    end
  end
end
