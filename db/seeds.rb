require 'csv'

subject_csv_path = File.expand_path('../../data/subjects.csv', __FILE__)

CSV.foreach(subject_csv_path, headers: true) do |row|
  subject = Subject.new
  subject.label = row['label']

  subject.drupal_node_id = row['taxonomy_id']

  subject.save!
end