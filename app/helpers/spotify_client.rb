#This should be a Singleton, injected in controllers, how do I do that?
class SpotifyClient

  def initialize(args)
    @client_id = args[:client_id]
    @secret = args[:secret]

    if !(@client_id && @secret)
      raise ArgumentError, 'Spotify Client Id and Spotify secret are mandatory'
    end

  end

  def get_user_login_url(scopes, redirect_to, random_check)

    query_params = URI.encode_www_form({
      :client_id => @client_id,
      :response_type => 'code',
      :redirect_uri => redirect_to,
      :scope => scopes.join(' '),
      :state =>random_check
    })

    "https://accounts.spotify.com/authorize/?#{query_params}"
  end

  def authorize(spotify_auth_code, redirect_to, random_value_sent=nil, random_value_returned=nil)

    unless random_value_sent.eql? random_value_returned

      #how do I inject the logger to this class?
      # logger.error "The state sent with the authorization request: #{random_value_sent} does not match the one returned by Spotify #{random_value_returned}"
      raise SecurityError, 'Seems the request has been tempered with, the state values do not match'
    end

    nil

    # begin
    #   response = RestClient.post('https://accounts.spotify.com/api/token', {
    #     grant_type: 'authorization_code',
    #     code: spotify_auth_code,
    #     redirect_uri: redirect_to
    #   }, {:Authorization => "Basic #{authorization_code}"})

    # rescue Exception => e
    #   logger.error "Error getting the token from Spotify: #{e.message}"
    #   redirect_to "/spotify"
    #   return
    # end

  end

  private
    def authorization_code
      Base64.strict_encode64("#{@client_id}:#{@secret}")
    end
end