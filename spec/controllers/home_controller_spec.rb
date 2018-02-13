RSpec.describe HomeController do
  before do
    get :index
  end

  describe "the base object" do
    subject { json }

    it { should include *%w(status counts) }
  end

  describe "the counts object" do
    before do
      @keys = %w(
        authors
        items
        ledgers
        loans
        patrons
        subjects
        works
      )

      @counts = json['counts']
    end
   
    subject { @counts }

    it { should be_a Hash }
    it { should include *@keys }

    it "should have counts attached to each key" do
      @keys.each do |key|
        expect(@counts[key]).to be_an Integer
      end
    end
  end
end