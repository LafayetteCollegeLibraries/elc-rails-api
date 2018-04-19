class WorkPresenter < BasePresenter
  def linked_authors
    return '(no author)' unless authors.length > 0

    authors.map { |author| h.link_to author.name, author }.join(', ').html_safe
  end

  def inline_subject_list
    return nil unless subjects.length > 0

    list_class = 'list-inline'
    list_item_class = 'list-inline-item'

    # wrap lh tag in an array to merge with items via `+` operator
    header = [content_tag(:lh, 'Subjects', class: list_item_class)]

    items = subjects.map do |subject|
      content_tag(:li, h.link_to(subject.label, subject), class: list_item_class)
    end

    content_tag(:ul, (header + items).join.html_safe, class: 'work-subjects list-inline')
  end

  def location
    "#{format} #{number}"
  end
end
