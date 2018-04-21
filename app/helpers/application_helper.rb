module ApplicationHelper
  def present(object, klass=nil)
    klass ||= begin
                "#{object.class}Presenter".constantize
              rescue NameError
                BasePresenter
              end
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end
end
