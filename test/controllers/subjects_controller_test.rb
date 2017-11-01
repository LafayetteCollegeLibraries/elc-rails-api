require 'test_helper'

class SubjectsControllerTest < ActionDispatch::IntegrationTest
  # /subjects

  test "index route contains `data` and `meta` keys" do
    get '/subjects'
    response = JSON.parse @response.body

    assert response.key? 'data'
    assert response.key? 'meta'
  end

  test "index route allows limiting" do
    per_page = 1

    get "/subjects?per_page=#{per_page}"
    response = JSON.parse @response.body

    assert_equal per_page, response['data'].count
  end

  test "index route allows pagination" do
    get "/subjects?page=1&per_page=1"
    data_1 = JSON.parse(@response.body)['data']

    get "/subjects?page=2&per_page=1"
    data_2 = JSON.parse(@response.body)['data']

    assert_not_equal data_1, data_2
  end

  test "each subject contains an `id` and `label`" do
    get "/subjects"
    response = JSON.parse @response.body

    response['data'].each do |subject|
      assert subject.key? 'id'
      assert subject.key? 'label'
    end
  end

  test "meta object contains the total count" do
    get "/subjects"
    response = JSON.parse @response.body

    assert_equal Subject.count, response['meta']['total']
  end


  # /subjects/:id

  test "single subject has `id` and `label`" do
    get "/subjects/1"
    response = JSON.parse @response.body

    assert response.key? 'id'
    assert response.key? 'label'
  end
end
