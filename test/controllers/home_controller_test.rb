require 'test_helper'
require 'json'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "shows an emoji" do
    get '/', as: :json
    json_body = JSON.parse @response.body

    assert_equal json_body['status'], '🎃'
  end
end