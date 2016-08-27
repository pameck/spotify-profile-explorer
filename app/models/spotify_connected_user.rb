class SpotifyConnectedUser
  include ActiveModel::Model

  ME_API_URL = 'https://api.spotify.com/v1/me'

  attr_reader :temporary_access_to_the_token_while_refactoring

  def initialize(access_token:, refresh_token:, auth_header:)
    @access_token = access_token
    @refresh_token = refresh_token
    @auth_header = auth_header

    if !@access_token
      raise ArgumentError, 'Spotify User Access Token not provided'
    end

    if !@refresh_token
      raise ArgumentError, 'Spotify User Refresh Token not provided'
    end

    if !@auth_header
      raise ArgumentError, 'Spotify App Auth Header not provided'
    end

    @temporary_access_to_the_token_while_refactoring = access_token

  end
end
