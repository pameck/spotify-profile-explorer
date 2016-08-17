require 'rest-client'
require 'uri'

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
    redirect_to "/spotify/dashboard"
  end

  def dashboard
    render "dashboard"
  end
end
