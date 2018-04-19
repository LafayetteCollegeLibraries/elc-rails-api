class BasePresenter < SimpleDelegator
  include ActionView::Helpers::TagHelper

  def initialize(model, view)
    @view = view
    super(model)
  end

  def h
    @view
  end
  
  # def method_missing(*args, &block)
  #   @view.send(*args, &block)
  # end
end
