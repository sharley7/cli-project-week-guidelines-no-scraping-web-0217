require 'pry'
class ExampleCLI

attr_accessor :input, :search, :artist_name, :artist_data
@@pop_arr = []

  def call
    puts "Welcome, to the Spotify Popular Artist CLI interface app,"
    puts "where you can search for artists based on popularity by genre!"
    puts
    run
  end

  def get_user_input
    gets.chomp.strip
  end

  def run
   help
   input = ""
   while input
     input = get_user_input
     case input
     when "help"
      help
    when "exit"
      exit
    when "search"
      puts "Enter a genre:"
        @input = get_user_input
        search
        puts "Enter a popularity number between 1-100"
        @input = get_user_input
        popularity_filter
        return_names
    when "genre"
        genre
    else
      help
    end
  end
  end

  def input
    @input
  end


  def search
    search_term = input.split(" ").join("%20").downcase
    puts "Your search term was #{input.capitalize}, I am searching..."
    artist_data = ""

    counter = 0
    ##This block runs the API request 5 times and incremets the offset by 50 to pull more results
    5.times do
    url = "http://api.spotify.com/v1/search?q=genre:#{search_term}&limit=50&offset=#{counter}&type=artist"
    artist_data = ExampleApi.new(url).list_artists
    counter += 50
     end

    puts "Thank you for your patience. I found this on Spotify:"
    artist_data.each_with_index do |(artist, pop), index |
      puts " #{index + 1}. #{artist}"
    end
    @artist_data = artist_data
  end

  def popularity_filter
    popularity_input = input.to_i
    #Input is a string, so has to be change to an integer
    puts "Returning all artists with a popularity of more than #{popularity_input}"
    artist_data.each do | artist, pop |
      pop.each do |k,v|
        if v < popularity_input
          @@pop_arr << artist
          #pushing any artist with a popularity greater than input...can probably reconfinger this to accept a range
        end
      end
    end
  end

 #broke this into a separate method
  def return_names
    puts "Here are the artists that meet your parameters:"
    @@pop_arr.each do | artist |
    puts "#{artist}"
  end
  end

  def help
    puts "Type 'genre' for a list of genres."
    puts "Type 'search' to search by genre and popularity."
    puts "Type 'exit' to exit."
    puts "Type 'help' to view this menu again."
  end

end
