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

  test 'index route allows pagination' do
    get '/authors?page=1&per_page=1'
    data_1 = JSON.parse(@response.body)['data']

    get '/authors?page=2&per_page=1'
    data_2 = JSON.parse(@response.body)['data']

    assert_not_equal data_1, data_2
  end

  test 'each author contains an `id`, `name`, and `types`' do
    get '/authors'
    response = JSON.parse @response.body

    response['data'].each do |author|
      assert author.key? 'id'
      assert author.key? 'name'
      assert author.key? 'types'
      
      assert_equal ['Author'], author['types']
    end
  end

  test 'meta object contains the total count' do
    get '/authors'
    response = JSON.parse @response.body

    assert_equal Author.count, response['meta']['total']
  end

  # /authors/:id

  test 'single author contains `id`, `name`, and `types`' do
    mary_shelley = authors(:mary_shelley)

    get "/authors/#{mary_shelley.id}"
    author = JSON.parse @response.body

    assert author.key? 'id'
    assert_equal mary_shelley.id, author['id']
    assert author.key? 'name'
    assert_equal mary_shelley.name, author['name']
    assert author.key? 'types'
    assert_equal ['Author'], author['types']
  end
end
