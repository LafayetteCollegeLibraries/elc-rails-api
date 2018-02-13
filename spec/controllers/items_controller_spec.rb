RSpec.describe ItemsController do
  describe '#index' do
    before do
      work = create(:work)
      @items = create_list(:item, 3, work: work)
      get :index, params: { work_id: work.id }
    end

    subject { json }
    it { should include *%w(data meta) }

    describe "response.body['data']" do
      subject { json['data'] }

      it { should be_an Array }
      its(:length) { should eq 3 }
    end
  end
end