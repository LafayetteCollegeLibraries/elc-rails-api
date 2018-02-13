RSpec.describe WorksController do
  describe '#index' do
    before :example do
      Work.delete_all
      
      create(:work)

      @authors = create_list(:author, 2)
      @authors.each do |author|
        create(:work, authors: [author])
      end

      @subjects = create_list(:subject, 2)
      @subjects.each do |subject|
        create(:work, subjects: [subject])
      end
    end

    context 'when no ids are passed' do
      before do
        get :index
      end

      subject { json['data'] }
      its(:length) { should eq 5 }
    end

    context 'when :author_id provided' do
      before do
        get :index, params: { author_id: @authors.first.id }
      end

      subject { json['data'] }
      its(:length) { should eq 1 }
    end

    context 'when :subject_id provided' do
      before do
        get :index, params: { subject_id: @subjects.first.id }
      end

      subject { json['data'] }
      its(:length) { should eq 1 }
    end
  end

  describe '#show' do
    before :example do
      @work = create(:work)
      get :show, params: { id: @work.id }
    end

    subject { json }

    it { should be_a Hash }
    it { should include *%w(authors format id number subjects title) }
    it { should_not include *%w(drupal_node_id drupal_node_type) }
  end
end