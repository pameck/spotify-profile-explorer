require 'test_helper'

class SpotifyControllerTest < ActionDispatch::IntegrationTest

  test "should redirect to Spotify Auth on request to /login" do
    get "/spotify/login"
    assert_response :redirect
  end

end
