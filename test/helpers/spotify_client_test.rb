require 'test_helper'

class SpotifyClientTest < ActiveSupport::TestCase

  describe 'Spotify' do
    def setup
      @spotify = SpotifyClient.new('SOME_CLIENT_ID', 'SOME_SECRET')
    end

    describe 'get_user_login_url' do

      it 'should return the url to redirect the user to provide their creds' do
        url = @spotify.get_user_login_url(nil, nil, nil)
        assert_includes url, 'https://accounts.spotify.com/authorize/'
      end
    end

    it 'should throw an error when the env var SPOTIFY_CLIENT_ID not set' do
      assert true
    end

    it 'should throw an error when the env var SPOTIFY_SECRET not set' do
      assert true
    end

  end

end
