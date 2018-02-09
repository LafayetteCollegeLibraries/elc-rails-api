RSpec.describe Item do
  it { should belong_to :work }
  it { should have_and_belong_to_many :loans }
  it { should respond_to :issue }
  it { should respond_to :volume }
  it { should respond_to :year }

  context 'with an base work' do
    subject { create(:item) }

    its(:title) { should eq subject.work.title }
    its(:full_title) { should eq subject.work.full_title }
  end

  context 'with a work with subjects' do
    subject { create(:item, work: create(:work_with_subjects)) }

    its(:subjects) { should eq subject.work.subjects }
  end

  context 'with a work with authors' do
    subject { create(:item, work: create(:work_with_authors)) }

    its(:authors) { should eq subject.work.authors }
  end
end