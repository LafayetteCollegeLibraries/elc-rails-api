RSpec.describe AuthorsController do
  describe 'GET #index' do
    before do
      get :index
    end

    subject { json }
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
      @name = 'Piggy, Miss'
      @target = create(:author, name: @name)
      @pool = create_list(:author, 20)

      get :search, params: { q: @name }
    end

    after do
      @target.delete
      @pool.each { |a| a.delete }
    end

    subject { json }
    it { should include *%w(data meta) }

    describe "response.body['data']" do
      subject { json['data'] }

      it { should_not be_empty }
      its(:length) { should eq 1 }
    end
  end

  describe 'GET #show' do
    before do
      target = create(:author, name: 'Piggy, Miss')
      get :show, params: { id: target.id }
    end

    describe "its payload object" do
      subject { json }

      it { should be_a Hash }
      it { should include *%w(name id types) }
      it { should_not include *%w(drupal_node_id drupal_node_type) }
    end
  end
end