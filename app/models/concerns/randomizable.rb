module Randomizable
  extend ActiveSupport::Concern

  module ClassMethods
    def random
      find(random_id)
    end

    def random_id
      rand(count)
    end
  end
end