class SpotifyConnectedUser
  include ActiveModel::Model

  ME_API_URL = 'https://api.spotify.com/v1/me'
  TOP_TRACKS = ME_API_URL + '/top/tracks'

  def initialize(access_token:, refresh_token:)
    @access_token = access_token
    @refresh_token = refresh_token

    if !@access_token
      raise ArgumentError, 'Spotify User Access Token not provided'
    end

    if !@refresh_token
      raise ArgumentError, 'Spotify User Refresh Token not provided'
    end
  end

  def get_profile
    begin
      response = RestClient.get(ME_API_URL, {:Authorization => "Bearer #{@access_token}"})
    rescue Exception => e
      raise SecurityError, 'Error accessing the user profile in Spotify'
    end

    parse_user(JSON.parse(response.body))
  end

  def get_top_tracks
    begin
      response = RestClient.get(TOP_TRACKS, {:Authorization => "Bearer #{@access_token}"})
    rescue Exception => e
      raise SecurityError, 'Error getting the top tracks for the user in Spotify'
    end
    parse_tracks_list(JSON.parse(response.body))
  end

  private
    def parse_user (spotify_response)
      UserProfile.new(
        name: spotify_response['display_name'],
        image: spotify_response.dig('images', 0, 'url'))
    end

    def parse_tracks_list (spotify_tracks_list)
      spotify_tracks_list['items'].map { |spotify_track|
        parse_track(spotify_track)
      }
    end

    def parse_track(spotify_track)
      Track.new(
        name: spotify_track['name'],
        spotify_id: spotify_track['id'],
        artist: spotify_track['artists'].first['name'],
        album: spotify_track['album']['name'])
    end
end
