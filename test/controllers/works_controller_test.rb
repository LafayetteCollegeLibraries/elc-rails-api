require 'test_helper'

class WorksControllerTest < ActionDispatch::IntegrationTest
  # /works

  test 'index route contains `data` and `meta` keys' do
    get '/works'
    response = JSON.parse @response.body

    assert response.key? 'data'
    assert response.key? 'meta'
  end

  test 'index route allows limiting' do
    per_page = 1

    get "/works?per_page=#{per_page}"
    response = JSON.parse @response.body

    assert_equal per_page, response['data'].count
  end

  test 'index route allows pagination' do
    get '/works?page=1&per_page=1'
    data_1 = JSON.parse(@response.body)['data']

    get '/works?page=2&per_page=1'
    data_2 = JSON.parse(@response.body)['data']

    assert_not_equal data_1, data_2
  end

  test 'each work contains appropriate fields' do
    fields = ['id', 'title', 'subjects', 'author']

    get '/works'
    response = JSON.parse @response.body

    response['data'].each do |work|
      work.keys.each do |field|
        assert fields.include? field
      end
    end
  end

  test 'meta object contains the total count' do
    get '/works'
    response = JSON.parse @response.body

    assert_equal Work.count, response['meta']['total']
  end

  # /works/:id

  test 'single work has appropriate fields' do
    fields = ['id', 'title', 'subjects', 'author']

    lunch_poems = works(:lunch_poems)
    get "/works/#{lunch_poems.id}"

    response = JSON.parse @response.body

    response.keys.each do |key|
      assert fields.include? key
    end
  end
end
