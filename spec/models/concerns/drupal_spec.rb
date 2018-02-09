RSpec.describe Drupal do
  before do
    class Drupalable
      include Drupal
      attr_accessor :drupal_node_id, :drupal_node_type
    end
  end

  # borrowed from
  # https://github.com/samvera/hyrax/blob/0dd1b0f/spec/models/hyrax/work_behavior_spec.rb#L7-L9
  after do
    Object.send(:remove_const, :Drupalable)
  end

  let(:drupal_node_id) { '1234' }

  context 'when drupal_node_type is "node"' do
    subject do
      Drupalable.new.tap do |d|
        d.drupal_node_id = drupal_node_id
        d.drupal_node_type = 'node'
      end
    end

    its(:drupal_url) { should include drupal_node_id }
    its(:drupal_url) { should include 'node' }
  end

  context 'when drupal_node_type is "taxonomy"' do
    subject do
      Drupalable.new.tap do |d|
        d.drupal_node_id = drupal_node_id
        d.drupal_node_type = 'taxonomy'
      end
    end

    its(:drupal_url) { should include drupal_node_id }
    its(:drupal_url) { should include 'taxonomy/term' }
  end
end