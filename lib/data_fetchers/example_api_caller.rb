require "pry"
class ExampleApi

  attr_reader :url, :artist_data, :artist_name
 @@artists = []

  def initialize(url)
    @url = url
    @artist_data = JSON.parse(RestClient.get(url))
  end


  def list_artists
    artists = []
    all_artists = artist_data["artists"]["items"]
    all_artists.each do | artist |
      artist_name = artist["name"]
      artists << artist_name
    end
    artists
  end

end
