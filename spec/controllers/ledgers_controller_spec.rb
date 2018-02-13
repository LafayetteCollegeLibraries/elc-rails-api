RSpec.describe LedgersController do
  before do
    @ledger = Ledger.create
  end

  after do
    Ledger.destroy_all
  end

  describe '#index' do
    before do 
      get :index
    end

    subject { json }
    it { should be_a Hash }
    it { should include *%w(data meta) }

    describe "response.body['data']" do
      subject { json['data'] }
      it { should be_an Array }
      its(:length) { should eq 1 }
    end

    describe "response.body['meta']" do
      subject { json['meta'] }
      it { should be_a Hash }
      it { should include *%w(page per_page total total_pages) }
    end
  end

  describe '#show' do
    before do
      get :show, params: { id: @ledger.id }
    end

    subject { json }
    it { should be_a Hash }
    it { should include *%w(id loans) }
    its(:count) { should be_an Integer }
  end
end