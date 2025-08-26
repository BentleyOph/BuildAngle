require "test_helper"

class WebsiteRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get website_requests_new_url
    assert_response :success
  end

  test "should get create" do
    get website_requests_create_url
    assert_response :success
  end
end
