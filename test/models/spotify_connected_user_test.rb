require 'test_helper'

class SpotifyConnectedUserTest < ActiveSupport::TestCase

  describe 'get_profile' do
    before do
      @connected_user = SpotifyConnectedUser.new(access_token: 'multipass', refresh_token: 'refreshing')

      stub_request(:get, 'https://api.spotify.com/v1/me')
      .with(headers: { Authorization: 'Bearer multipass' })
      .to_return(
        body: '{"display_name": "Lilu Dallas", "images": [ {"url": "https://images.spotify.com/liludallas"}]}',
        status: 200)
    end

    it 'should return the user profile information' do
      profile_info = @connected_user.get_profile

      expect(profile_info.name).must_equal 'Lilu Dallas'
      expect(profile_info.image).must_equal 'https://images.spotify.com/liludallas'
    end
  end

  it 'should raise error when Spotify access token not set' do
    err = assert_raises ArgumentError do
      SpotifyConnectedUser.new(access_token: nil, refresh_token: 'refreshing')
    end
    expect(err.message).must_equal 'Spotify User Access Token not provided'
  end

  it 'should raise error when Spotify refresh token not set' do
    err = assert_raises ArgumentError do
      SpotifyConnectedUser.new(access_token: 'secret', refresh_token: nil)
    end
    expect(err.message).must_equal 'Spotify User Refresh Token not provided'
  end

end
