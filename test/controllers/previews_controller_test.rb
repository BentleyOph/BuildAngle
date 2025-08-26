require "test_helper"

class PreviewsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get previews_show_url
    assert_response :success
  end
end
