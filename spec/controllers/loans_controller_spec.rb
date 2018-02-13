RSpec.describe LoansController do
  describe '#index' do
    after do
      Loan.destroy_all
    end

    context 'its default behavior' do
      before do
        create(:loan)
        get :index
      end

      subject { json }
      it { should be_a Hash }
      it { should include *%w(data meta) }

      describe "response.body['data']" do
        subject { json['data'] }
        it { should be_an Array }
        it { should_not be_empty }
      end

      describe "response.body['meta']" do
        subject { json['meta'] }
        it { should be_a Hash }
        it { should include *%w(page total per_page total_pages) }
      end
    end

    context 'when :ledger_id passed' do
      before do
        loan = create(:loan)
        ledger = Ledger.create do |l|
          l.loans << loan
        end

        get :index, params: { ledger_id: ledger.id }
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

    context 'when :work_id passed' do
      before do
        work = create(:work)
        loan = create(:loan, items: [create(:item, work: work)])

        get :index, params: { work_id: work.id }
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

    context 'when :patron_id passed + the patron is a shareholder' do
      before do
        patron = create(:shareholder)
        loan = create(:loan, shareholder: patron)

        get :index, params: { patron_id: patron.id }
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

    context 'when :patron_id passed + the patron is a representative' do
      before do
        patron = create(:representative)
        loan = create(:loan, representative: patron)

        get :index, params: { patron_id: patron.id }
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
  end

  describe '#show' do
    before do
      @fields = %w(
        id
        label
        work
        volumes
        issues
        years
        checkout_date
        return_date
        representative
        shareholder
        ledger
      )
      @loan = create(:loan)
      get :show, params: { id: @loan.id }
    end

    subject { json }
    it { should be_a Hash }
    it { should include *@fields }
    it { should_not include *%w(drupal_node_id drupal_node_type) }
  end
end