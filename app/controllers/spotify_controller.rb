class SpotifyController < ActionController::Base
  protect_from_forgery with: :exception

  def show
    render "index"
  end
end
