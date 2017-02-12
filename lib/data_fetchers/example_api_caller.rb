# require "pry"
# class ExampleApi
#
#   attr_reader :url, :artist_data, :artist_name
#   #Turned artist into a hash to accept the new k/v pairs of artist and popularity
#  @@artist_hash = {}
#
#
#   def initialize(url)
#     @url = url
#     @parsed_artist_data = JSON.parse(RestClient.get(url))
#   end
#
#   def artists
#     @@artist_hash
#   end
#
#   #created new hashes from artist/popularity keys
#   def list_artists
#     next_page_url = @parsed_artist_data["artists"]["next"]
#
#     until next_page_url == nil
#
#       all_artist_data_array = @parsed_artist_data["artists"]["items"]
#
#       all_artist_data_array.each do | attribute_hash |
#               each_artist_name = attribute_hash["name"]
#               @@artist_hash[each_artist_name] ||= {}
#               @@artist_hash[each_artist_name][:popularity] = attribute_hash["popularity"]
#               @@artist_hash[each_artist_name][:followers] = attribute_hash["followers"]["total"]
#       end
#     end
#
#     @@artist_hash
#   end
#
# end
