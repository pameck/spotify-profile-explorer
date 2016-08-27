#This should be a Singleton, injected in controllers, how do I do that?
class SpotifyClient

  attr_reader :scope

  @@all_scopes = ['playlist-read-private',
    'playlist-read-collaborative',
    'user-follow-read',
    'user-library-read',
    'user-read-private',
    'user-top-read']

  def initialize(client_id:, secret:, scope: @@all_scopes)
    @client_id = client_id
    @secret = secret
    @scope = scope

    if !(@client_id && @secret)
      raise ArgumentError, 'Spotify Client Id and Spotify secret are mandatory'
    end

  end

  def get_user_login_url(redirect_to, random_check)

    query_params = URI.encode_www_form({
      :client_id => @client_id,
      :response_type => 'code',
      :redirect_uri => redirect_to,
      :scope => @scope.join(' '),
      :state =>random_check
    })

    "https://accounts.spotify.com/authorize?#{query_params}"
  end

  def connect(spotify_auth_code, redirect_to, random_value_sent=nil, random_value_returned=nil)

    unless random_value_sent.eql? random_value_returned
      #how do I inject the logger to this class?
      # logger.error "The state sent with the authorization request: #{random_value_sent} does not match the one returned by Spotify #{random_value_returned}"
      raise SecurityError, 'Seems the request has been tempered with, the state values do not match'
    end

    begin
      response = RestClient.post('https://accounts.spotify.com/api/token', {
        grant_type: 'authorization_code',
        code: spotify_auth_code,
        redirect_uri: redirect_to
      }, {:Authorization => "Basic #{get_authorization_header}"})

      return SpotifyConnectedUser.new({
          refresh_token: JSON.parse(response.body)['refresh_token'],
          access_token: JSON.parse(response.body)['access_token'],
          auth_header: get_authorization_header
        })

    rescue Exception => e
      # logger.error "Error getting the token from Spotify: #{e.message}"
      raise SecurityError, 'Authorization denied by Spotify'
    end
  end

  private
    def get_authorization_header
      Base64.strict_encode64("#{@client_id}:#{@secret}")
    end
end