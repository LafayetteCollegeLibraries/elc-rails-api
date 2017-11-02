require 'test_helper'

class AuthorsControllerTest < ActionDispatch::IntegrationTest
  # /authors

  test 'index route contains `data` and `meta` keys' do
    get '/authors'
    response = JSON.parse @response.body

    assert response.key? 'data'
    assert response.key? 'meta'
  end

  test 'index route allows limiting' do
    per_page = 1

    get "/authors?per_page=#{per_page}"
    response = JSON.parse @response.body

    assert_equal per_page, response['data'].count
  end
end
