RSpec.describe ItemsController do
  describe '#index' do
    let(:work) { create(:work) }
    let!(:items) { create_list(:item, 3, work: work) }

    before do
      get :index, params: { work_id: work.id }
    end

    describe 'response.body' do
      subject { json }

      it { is_expected.to include 'data', 'meta' }
    end

    describe "response.body['data']" do
      subject { json['data'] }

      it { is_expected.to be_an Array }
      its(:length) { is_expected.to eq 3 }
    end
  end
end
