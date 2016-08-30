# Spotify Profile Explorer

This is a Web application that will let you find things about your Spotify profile you didn't know about.

## Installation

### Clone the repository
`git clone git@github.com:pameck/spotify-profile-explorer.git`

### Register your App in Spotify
0. Go to [Spotify Dev Website](https://developer.spotify.com/my-applications/#!/applications) and create an application.

0. Create `config/application.yml` and set the values for the following variables. (check `config/application.yml.example`). **Keep your application.yml private, do not commit it.**

```
SPOTIFY_CLIENT_ID: "The one given by Spotify when you created your app"
SPOTIFY_SECRET: "The one given by Spotify when you created your app"
SPOTIFY_REDIRECT_URL: "The one you set on Redirect URIs when you created your app"
```

### Install with Docker (Tuned for OSX)
_Requires docker, docker-machine and docker-compose_

0. Install VirtualBox with brew cask <br>
`brew cask install viritualbox`

0. Install Docker ToolBox (installs docker, docker-machine and docker-compose) <br>
`brew cask install docker-toolbox`

0. Create a docker machine <br>
`docker-machine create --driver virtualbox default`

0. Export docker env variables <br>
`eval "$(docker-machine env default)"`

### Build the application (from inside the application folder)

`docker-compose build`

### Run the application

`docker-compose up`

### Run the tests

`docker-compose run web rake test`