require 'rest-client'
require 'uri'
require 'base64'

class SpotifyController < ActionController::Base
  protect_from_forgery with: :exception

  def show
    render "index"
  end

  def login_user
    @spotify_random = SecureRandom.hex

    query_params = URI.encode_www_form({
      :client_id => ENV['SPOTIFY_CLIENT_ID'],
      :response_type => 'code',
      :redirect_uri => ENV['SPOTIFY_REDIRECT_URL'],
      :scope => 'user-read-private user-read-email',
      :state => @spotify_random
    })

    redirect_to("https://accounts.spotify.com/authorize/?#{query_params}")
  end

  def authorize_finish
    @spotify_auth_code = request.query_parameters['code']
    authorization = Base64.strict_encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_SECRET']}")

    begin
      response = RestClient.post('https://accounts.spotify.com/api/token', {
        grant_type: 'authorization_code',
        code: @spotify_auth_code,
        redirect_uri: ENV['SPOTIFY_REDIRECT_URL']
      },

      {:Authorization => "Basic #{authorization}"})
    rescue Exception => e
      redirect_to "/spotify"
      return
    end

    redirect_to "/spotify/dashboard"
  end

  def dashboard
    render "dashboard"
  end
end