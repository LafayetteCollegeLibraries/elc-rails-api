require 'test_helper'

class PatronsControllerTest < ActionDispatch::IntegrationTest
  # /patrons

  test 'index route contains `data` and `meta` keys' do
    get '/patrons'
    response = JSON.parse @response.body

    assert response.key? 'data'
    assert response.key? 'meta'
  end

  test 'index route allows limiting' do
    per_page = 1

    get "/patrons?per_page=#{per_page}"
    response = JSON.parse @response.body

    assert_equal per_page, response['data'].count
  end

  test 'index route allows pagination' do
    get '/patrons?page=1&per_page=1'
    data_1 = JSON.parse(@response.body)['data']

    get '/patrons?page=2&per_page=1'
    data_2 = JSON.parse(@response.body)['data']

    assert_not_equal data_1, data_2
  end

  test 'each patron contains `id`, `name`, and `types` keys' do
    get '/patrons'
    response = JSON.parse @response.body

    response['data'].each do |patron|
      assert patron.key? 'id'
      assert patron.key? 'name'
      assert patron.key? 'types'
    end
  end

  # /patrons/:id

  test 'individual patrons contain `id`, `name`, and `types` keys' do
    laurie = patrons(:laurie_strode)
    get "/patrons/#{laurie.id}"

    patron = JSON.parse @response.body

    assert patron.key? 'id'
    assert patron.key? 'name'
    assert patron.key? 'types'
  end
end
