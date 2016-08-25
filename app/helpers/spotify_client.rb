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
end