require 'csv'

subject_csv_path = File.expand_path('../../data/subjects.csv', __FILE__)
CSV.foreach(subject_csv_path, headers: true) do |row|
  subject = Subject.new
  
  subject.label = row['label']
  subject.drupal_node_id = row['taxonomy_id']
  subject.drupal_node_type = 'taxonomy'

  subject.save!
end

author_csv_path = File.expand_path('../../data/authors.csv', __FILE__)
CSV.foreach(author_csv_path, headers: true) do |row|
  author = Author.new

  author.name = row['name']
  author.drupal_node_id = row['node_id']
  author.drupal_node_type = 'node'

  author.save!
end