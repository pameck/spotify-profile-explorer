class SpotifySession
  attr_reader :access_token, :refresh_token

  def initialize(args)
    @access_token   = args[:access_token]
    @refresh_token  = args[:refresh_token]
  end
end