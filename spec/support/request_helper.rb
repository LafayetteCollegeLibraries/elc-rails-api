# h/t http://www.thegreatcodeadventure.com/better-rails-5-api-controller-tests-with-rspec-shared-examples/
module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end
  end
end