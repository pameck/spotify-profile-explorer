module Spotify

  ALL_SCOPES = ['playlist-read-private',
    'playlist-read-collaborative',
    'playlist-modify-public',
    'playlist-modify-private',
    'user-follow-modify',
    'user-follow-read',
    'user-library-read',
    'user-library-modify',
    'user-read-private',
    'user-read-birthdate',
    'user-read-email',
    'user-top-read']

  def self.parse (spotify_user)
    User.new(
      name: spotify_user['display_name'],
      country: spotify_user['country'],
      image: spotify_user['images'].first['url'],
      product: spotify_user['product'],
      email: spotify_user['email'])
  end
end