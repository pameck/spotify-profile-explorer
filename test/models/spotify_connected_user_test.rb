require 'test_helper'

class SpotifyConnectedUserTest < ActiveSupport::TestCase

  test 'should raise error when Spotify access token not set' do
    err = assert_raises ArgumentError do
      SpotifyConnectedUser.new(access_token: nil, refresh_token: 'refreshing', auth_header: 'authorised')
    end
    expect(err.message).must_equal 'Spotify User Access Token not provided'
  end

  it 'should raise error when Spotify refresh token not set' do
    err = assert_raises ArgumentError do
      SpotifyConnectedUser.new(access_token: 'secret', refresh_token: nil, auth_header: 'authorised')
    end
    expect(err.message).must_equal 'Spotify User Refresh Token not provided'
  end

  it 'should raise error when Spotify app auth header not set' do
    err = assert_raises ArgumentError do
      SpotifyConnectedUser.new(access_token: 'secret', refresh_token: 'refreshing', auth_header: nil)
    end
    expect(err.message).must_equal 'Spotify App Auth Header not provided'
  end

end
