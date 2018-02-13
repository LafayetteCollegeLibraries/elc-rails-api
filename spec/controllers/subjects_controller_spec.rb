RSpec.describe SubjectsController do
  describe 'GET #index' do
    before do
      get :index
    end

    let(:target) { create(:subject) }

    subject { JSON.parse(response.body) }
    it { should include *%w(data meta) }

    describe "response.body['data']" do
      subject { json['data'] }
      it { should be_an Array }
    end

    describe "response.body['meta']" do
      subject { json['meta'] }
      it { should be_a Hash }
      it { should include *%w(total page per_page total_pages) }
    end
  end

  describe 'GET #search' do
    before do
      term = 'SEARCH TERM'
      @label = "Here it is: [#{term}]"
      @target = create(:subject, label: @label)
      @pool = create_list(:subject, 20)

      get :search, params: { q: term }
    end

    after do
      @target.delete
      @pool.each { |s| s.delete }
    end

    subject { json }
    it { should include *%w(data meta)}

    describe "response.body['data']" do
      subject { json['data'] }

      it { should_not be_empty }
      its(:length) { should eq 1 }
    end
  end

  describe 'GET #show' do
    before do
      target = create(:subject, label: 'Cool Subject')
      get :show, params: { id: target.id }
    end

    subject { json }

    it { should include *%w(label id) }
    it { should_not include *%w(drupal_node_id drupal_node_type) }
  end
end