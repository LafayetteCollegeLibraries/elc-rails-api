class LoanPresenter < BasePresenter
  def links_to_items
    items.collect { |item| h.link_to(item.full_title, h.work_path(item.work)) }.join(', ').html_safe
  end

  def patron_template
    "loans/#{shareholder == representative ? 'single_patron' : 'multiple_patrons'}"
  end
end
