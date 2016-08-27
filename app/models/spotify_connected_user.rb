class SpotifyConnectedUser
  include ActiveModel::Model

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
end
