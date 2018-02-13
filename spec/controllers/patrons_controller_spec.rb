RSpec.describe PatronsController do
  describe '#index' do
    before do
      create_list(:shareholder, 2)
      create_list(:representative, 2)

      get :index
    end

    after do
      Patron.delete_all
    end

    subject { json }
    it { should be_a Hash }
    it { should include *%w(data meta) }

    describe "response.body['data']" do
      subject { json['data'] }
      it { should be_an Array }
      its(:length) { should eq 4 }
    end

    describe "response.body['meta']" do
      subject { json['meta'] }
      it { should be_a Hash }
      it { should include *%w(page total_pages per_page total) }
    end
  end

  describe '#search' do
    before do
      query = 'Kermit'
      @patron = create(:patron, name: 'Frog, Kermit')
      get :search, params: { q: query }
    end

    after do
      @patron.delete
    end

    subject { json }
    it { should be_a Hash }
    it { should include *%w(data meta) }

    describe "response.body['data']" do
      subject { json['data'] }
      it { should be_an Array }
      its(:length) { should eq 1 }
    end
  end

  describe '#show' do
    before do
      @patron = create(:patron)
      get :show, params: { id: @patron.id }
    end

    subject { json }
    it { should be_a Hash }
    it { should include *%w(name types id) }
    it { should_not include *%w(drupal_node_id drupal_node_type) }
  end 
end