require 'test_helper'

class SpotifyClientTest < ActiveSupport::TestCase

  describe 'Spotify' do
    before do
      @spotify = SpotifyClient.new(secret: 'SOMETHING', client_id: 'SOME_CLIENT_ID', scope: ['a-1', 'b-2'])
    end

    describe 'get_user_login_url' do
      before do
        @url = @spotify.get_user_login_url('http://localhost:444/crazy/callback', 'this_is_super_random')
      end

      it 'should return the url to redirect the user to provide their creds' do
        expect(@url).must_include('https://accounts.spotify.com/authorize')
        expect(@url).must_include('client_id=SOME_CLIENT_ID')
        expect(@url).must_include('response_type=code')
      end

      it 'should set the redirect_uri query param to the url encoded redirect_to argument' do
        expect(@url).must_include('redirect_uri=http%3A%2F%2Flocalhost%3A444%2Fcrazy%2Fcallback')
      end

      it 'should set the state param to the random_check argument' do
        expect(@url).must_include('state=this_is_super_random')
      end

      it 'should set the scope query param to a string made of the scopes sent in args' do
        expect(@url).must_include('scope=a-1+b-2')
      end
    end

    describe 'connect' do

      it 'should return a spotify session for a valid request' do
        stub_request(:post, 'https://accounts.spotify.com/api/token')
        .with(
          body: hash_including({
            grant_type: 'authorization_code',
            code: 'super_auth_code',
            redirect_uri: 'http://somewebsite.com/callback'
          }), headers: { Authorization: "Basic #{Base64.strict_encode64("SOME_CLIENT_ID:SOMETHING")}" })
        .to_return(body: '{"access_token": "token1", "refresh_token": "refresh1"}', status: 200)

        spotify_user = @spotify.connect('super_auth_code', 'http://somewebsite.com/callback', 'random 1', 'random 1')

        expect(spotify_user).wont_be_nil
        expect(spotify_user).must_be_instance_of SpotifyConnectedUser
      end

      it 'should not raise error if random values not defined' do
        stub_request(:post, 'https://accounts.spotify.com/api/token')
        .to_return(body: '{"access_token": "token1", "refresh_token": "refresh1"}', status: 200)

        spotify_user = @spotify.connect('super_auth_code', 'http://somewebsite.com/callback', nil, nil)

        expect(spotify_user).wont_be_nil
      end

      it 'should raise an error for an invalid request' do
        stub_request(:post, 'https://accounts.spotify.com/api/token')
        .to_return(status: 400)

        err = assert_raises SecurityError do
          spotify_user = @spotify.connect('code', 'redirect here', 'random 1', 'random 1')
        end
        assert_equal 'Authorization denied by Spotify', err.message
      end

      it 'should raise an error when the random values sent and returned do not match' do
        err = assert_raises SecurityError do
          spotify_user = @spotify.connect('code', 'redirect here', 'random 1', 'random 2')
        end
        assert_equal 'Seems the request has been tempered with, the state values do not match', err.message
      end
    end

    it 'should default to all scopes when scope not defined' do
      client = SpotifyClient.new(secret: 'SOME_SECRET', client_id: 'SOME_CLIENT_ID')
      expect(client.scope).wont_be_empty
    end

    it 'should throw an error when the client not set' do
      err = assert_raises ArgumentError do
        SpotifyClient.new(secret: 'SOMETHING', client_id: nil, scope: ['user-follow-read', 'user-top-read'])
      end
      assert_equal 'Spotify Client Id and Spotify secret are mandatory', err.message
    end

    it 'should throw an error when secret not set' do
      err = assert_raises ArgumentError do
        SpotifyClient.new(secret: nil, client_id: 'SOME_CLIENT_ID')
      end
      assert_equal 'Spotify Client Id and Spotify secret are mandatory', err.message
    end
  end

end
