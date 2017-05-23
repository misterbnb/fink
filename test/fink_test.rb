require 'test_helper'

class FinkTest < ActiveSupport::TestCase
  test "creates new record if everything's ok" do
    stub_request(:head, "http://www.misterbandb.com/some/image.jpg").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})

    FinkReport.create(
      url: 'http://www.misterbandb.com/some/image.jpg',
      kind: 'hosting',
      kind_id: 123
    )

    assert_equal 1, FinkReport.all.count
  end

  test "creates new record if everything's ok using SSL URL" do
    stub_request(:head, "https://www.misterbandb.com/some/image.jpg").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})

    FinkReport.create(
      url: 'https://www.misterbandb.com/some/image.jpg',
      kind: 'hosting',
      kind_id: 123
    )

    assert_equal 1, FinkReport.all.count
  end

  test "do not create record if url is blank" do
    FinkReport.create(
      url: '',
      kind: 'hosting',
      kind_id: 123
    )

    assert_equal 0, FinkReport.all.count
  end

  test "do not create record if url is local" do
    FinkReport.create(
      url: '/some/local/url',
      kind: 'hosting',
      kind_id: 123
    )

    assert_equal 0, FinkReport.all.count
  end
end
