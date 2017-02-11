require "pry"
class ExampleApi

  attr_reader :url, :artist_data, :artist_name
 @@artists = {}

  def initialize(url)
    @url = url
    @artist_data = JSON.parse(RestClient.get(url))
  end

  def artists
    @@artists
  end


  def list_artists
    all_artists = artist_data["artists"]["items"]
    all_artists.each_with_object({}) do | artist |
            artist_name = artist["name"]
            artists[artist_name] ||= {}
            artists[artist_name][:popularity] = artist["popularity"]
         end
    artists
  end

end
