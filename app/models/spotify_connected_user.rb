class SpotifyConnectedUser
  include ActiveModel::Model

  ME_API_URL = 'https://api.spotify.com/v1/me'

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
    response = RestClient.get(ME_API_URL, {:Authorization => "Bearer #{@access_token}"})
    parse_user(JSON.parse(response.body))
  end

  private
    def parse_user (spotify_response)
      UserProfile.new(
        name: spotify_response['display_name'],
        image: spotify_response.dig('images', 0, 'url'))
    end
end
