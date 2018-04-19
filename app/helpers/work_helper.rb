module WorkHelper
  def authors
    return '(no author)' unless @work.authors.length > 0

    @work.authors.map { |author| link_to author.name, author }.join(', ').html_safe
  end

  def inline_subject_list
    return nil unless @work.subjects.length > 0

    list_class = 'list-inline'
    list_item_class = 'list-inline-item'

    # wrap lh tag in an array to merge with items via `+` operator
    header = [content_tag(:lh, 'Subjects', class: list_item_class)]

    items = @work.subjects.map do |subject|
      content_tag(:li, link_to(subject.label, subject), class: list_item_class)
    end

    content_tag(:ul, (header + items).join.html_safe, class: 'work-subjects list-inline')
  end

  def location
    "#{@work.format} #{@work.number}"
  end
end
