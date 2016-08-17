require 'cgi'
require 'rest-client'

class SpotifyController < ActionController::Base
  protect_from_forgery with: :exception

  def show
    render "index"
  end

  def authorize
    go_to = CGI::escape('http://localhost:3000/spotify/validateauth')
    @spotify_random = SecureRandom.hex
    redirect_to("https://accounts.spotify.com/authorize/?client_id=#{ENV['SPOTIFY_CLIENT_ID']}&response_type=code&redirect_uri=#{go_to}&scope=user-read-private%20user-read-email&state=#{@spotify_random}")
  end

  def authorize_finish
    redirect_to "/spotify/dashboard"
  end

  def dashboard
    render "dashboard"
  end
end
