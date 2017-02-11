require 'pry'
class ExampleCLI

attr_accessor :input, :search, :artist_name

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
    url = "http://api.spotify.com/v1/search?q=genre:#{search_term}&limit=50&type=artist"
    artist_data = ExampleApi.new(url).list_artists
    puts "Thank you for your patience. I found this on Spotify:"
    artist_data.each_with_index do |artist, index |
      puts "#{index + 1 }. #{artist}"
    end
  end

  def help
    puts "Type 'genre' for a list of genres."
    puts "Type 'search' to search by genre and popularity."
    puts "Type 'exit' to exit."
    puts "Type 'help' to view this menu again."
  end

end
