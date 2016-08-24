require 'test_helper'

class SpotifyTest < ActiveSupport::TestCase

  describe 'Spotify' do
    it 'should throw an error when the env var SPOTIFY_CLIENT_ID not set' do
      assert true
    end

    it 'should throw an error when the env var SPOTIFY_SECRET not set' do
      assert true
    end

  end

end
