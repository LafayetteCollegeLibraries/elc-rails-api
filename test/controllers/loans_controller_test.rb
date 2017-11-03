require 'test_helper'

class LoansControllerTest < ActionDispatch::IntegrationTest
  test 'index route contains `data` and `meta` keys' do
    get '/loans'
    response = JSON.parse @response.body

    assert response.key? 'data'
    assert response.key? 'meta'
  end

  test 'index route allows limiting' do
    per_page = 1

    get "/loans?per_page=#{per_page}"
    response = JSON.parse @response.body

    assert_equal per_page, response['data'].count
  end

  test 'index route allows pagination' do
    get '/loans?page=1&per_page=1'
    data_1 = JSON.parse(@response.body)['data']

    get '/loans?page=2&per_page=1'
    data_2 = JSON.parse(@response.body)['data']

    assert_not_equal data_1, data_2
  end
end
