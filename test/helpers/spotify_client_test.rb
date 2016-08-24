require 'test_helper'

class SpotifyClientTest < ActiveSupport::TestCase

  describe 'Spotify' do
    before do
      @spotify = SpotifyClient.new('SOME_CLIENT_ID', 'SOME_SECRET')
    end

    describe 'get_user_login_url' do
      before do
        @url = @spotify.get_user_login_url(['a-1', 'b-2'], 'http://localhost:444/crazy/callback', 'this_is_super_random')
      end

      it 'should return the url to redirect the user to provide their creds' do
        assert_includes @url, 'https://accounts.spotify.com/authorize'
        assert_includes @url, 'client_id=SOME_CLIENT_ID'
        assert_includes @url, 'response_type=code'
      end

      it 'should set the redirect_uri query param to the url encoded redirect_to argument' do
        assert_includes @url, 'redirect_uri=http%3A%2F%2Flocalhost%3A444%2Fcrazy%2Fcallback'
      end

      it 'should set the state param to the random_check argument' do
        assert_includes @url, 'state=this_is_super_random'
      end

      it 'should set the scope query param to a string made of the scopes sent in args' do
        assert_includes @url, 'scope=a-1+b-2'
      end
    end

    it 'should throw an error when the env var SPOTIFY_CLIENT_ID not set' do
      err = assert_raises ArgumentError do
        SpotifyClient.new(nil, 'secret')
      end
      assert_equal 'Spotify Client Id and Spotify secret are mandatory', err.message
    end

    it 'should throw an error when the env var SPOTIFY_SECRET not set' do
      err = assert_raises ArgumentError do
        SpotifyClient.new('client', nil)
      end
      assert_equal 'Spotify Client Id and Spotify secret are mandatory', err.message
    end

  end

end
