RSpec.describe Item do
  it { is_expected.to belong_to :work }
  it { is_expected.to have_and_belong_to_many :loans }
  it { is_expected.to respond_to :issue }
  it { is_expected.to respond_to :volume }
  it { is_expected.to respond_to :year }

  context 'with an base work' do
    subject(:item) { create(:item) }

    its(:title) { is_expected.to eq item.work.title }
    its(:full_title) { is_expected.to eq item.work.full_title }
  end

  context 'with a work with subjects' do
    subject(:item) { create(:item, work: create(:work_with_subjects)) }

    its(:subjects) { is_expected.to eq item.work.subjects }
  end

  context 'with a work with authors' do
    subject(:item) { create(:item, work: create(:work_with_authors)) }

    its(:authors) { is_expected.to eq item.work.authors }
  end
end
