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

    it 'should raise error when there is an error getting the profile from Spotify' do
      stub_request(:get, 'https://api.spotify.com/v1/me')
      .to_return(status: 400)

      err = assert_raises SecurityError do
        @connected_user.get_profile
      end
      expect(err.message).must_equal 'Error accessing the user profile in Spotify'
    end

  end

  describe 'get_top_tracks' do

    before do
      @connected_user = SpotifyConnectedUser.new(access_token: 'multipass', refresh_token: 'refreshing')
      @top_tracks_sucessful_response = File.read(File.expand_path('../../data/top_tracks_sample_response.json', __FILE__))

      stub_request(:get, 'https://api.spotify.com/v1/me/top/tracks')
      .with(headers: { Authorization: 'Bearer multipass' })
      .to_return(
        body: @top_tracks_sucessful_response,
        status: 200)
    end

    it 'should return a list of tracks' do
      top_tracks = @connected_user.get_top_tracks
      expect(top_tracks).wont_be_empty

      southern_sun = top_tracks.select { |track| track.name.eql? 'Southern Sun'}.first
      expect(southern_sun).wont_be_nil
      expect(southern_sun.artist).must_equal 'Boy & Bear'
    end

    it 'should return an empty list of tracks if no top tracks available' do
      stub_request(:get, 'https://api.spotify.com/v1/me/top/tracks')
      .with(headers: { Authorization: 'Bearer multipass' })
      .to_return(
        body: '{"items":[],"total":0,"limit":20,"offset":0,"href":"https://api.spotify.com/v1/me/top/tracks","previous":null,"next":null}',
        status: 200)

      top_tracks = @connected_user.get_top_tracks
      expect(top_tracks).wont_be_nil
      expect(top_tracks).must_be_empty
    end

    it 'should raise an error when getting the top tracks from Spotify fails' do
      stub_request(:get, 'https://api.spotify.com/v1/me/top/tracks')
      .to_return(status: 400)

      err = assert_raises SecurityError do
        @connected_user.get_top_tracks
      end
      expect(err.message).must_equal 'Error getting the top tracks for the user in Spotify'
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
