require 'pry'
class ExampleCLI

attr_accessor :input, :search, :artist_name, :artist_data

 @@pop_arr = []
 @@artist_hash = {}

  def call
    puts
    puts "                      `.-:/+++oooooo++/:-.`
                `-/+ooooooooooooooooooooo+/:.
              .:+ooooooooooooooooooooooooooooo+:.
            -/ooooooooooooooooooooooooooooooooooo+-`
          -+ooooooooooooooooooooooooooooooooooooooo+:`
        `/ooooooooooooooooooooooooooooooooooooooooooo+-
      -+oooooooooooooooooooooooooooooooooooooooooooooo:`
      :oooooooooo++//:::::---::::://++oooooooooooooooooo/`
    :oooooo+-.``                      `..-:/+ooooooooooo/`
    -oooooo+                                  `-:+oooooooo:
  `+ooooooo-` ``.--::///////////::--..`          `-+oooooo.
  -oooooooooo+ooooooooooooooooooooooooo++/:.`      -oooooo/
  /ooooooooooooo++//::--------:://++ooooooooo+/-``-+ooooooo`
  +oooooooooo:.`                    `.-:/+ooooooooooooooooo.
  +ooooooooo+       ``........``          `.:+ooooooooooooo.
  +oooooooooo+::/++oooooooooooooo++/:-.`      `/ooooooooooo`
  :ooooooooooooooooooooooooooooooooooooo+/-`   :oooooooooo+
  .ooooooooooo+/::--..````````..--:/++oooooo+/+ooooooooooo:
    /ooooooooo+`           `           `-:+ooooooooooooooo+`
    `+ooooooooo/-:://++oooooooo++//:-.`    `:ooooooooooooo.
    `+oooooooooooooooooooooooooooooooo+:.` .+ooooooooooo-
      `+ooooooooooooooooooooooooooooooooooo+oooooooooooo-
      `/ooooooooooooooooooooooooooooooooooooooooooooo+.
        .+ooooooooooooooooooooooooooooooooooooooooo+:
          -+ooooooooooooooooooooooooooooooooooooo+:`
            ./ooooooooooooooooooooooooooooooooo+-`
              `-/+oooooooooooooooooooooooooo/:`
                  .-:++oooooooooooooooo+/:.`
                        `..--:::::---.`
                                               "

    puts "*" * 60
    puts "                  Welcome to SPACIAL"
    puts "  The Spotify Popular Artist CLI Interface Application."
    puts "Search for artists based on genre by popularity & followers!"
    puts "*" * 60
    puts

    run
  end

  def get_user_input
    gets.chomp.strip
  end

  def run
   help
   puts
   input = ""

   while input
     input = get_user_input

      if input == "help"
        help
      elsif input == "exit"
        puts
        puts "Thank you for using SPACIAL. See you next time!"
        puts

        exit
      elsif input == "search"
        puts
        puts "Enter a genre:"
        puts

        @input = get_user_input
        search

        after_search_query

        @input = get_user_input

        popularity_filter

        return_names
      elsif input == "genre"
        genre
      else
        puts
        puts "Oops! It looks like '#{input}' is not a valid command."
        puts

        help
      end
    end
  end

  def input
    @input
  end

  def after_search_query
    puts
    puts "That's list of #{@search_term.capitalize} artists"
    puts
    puts "New search terms! Sory by 'popularity' and 'followers'."
    puts
    puts "Type 'popularity' to sort by popularity"
    puts "Type 'followers' to sort artists by followers"
    puts "Type 'help to see the help menu'"
    puts

    input = ""
    while input
      input = get_user_input
      if input == "help"
        help
      elsif input == "exit"
        puts
        puts "Thank you for using SPACIAL. See you next time!"
        puts

        exit
      end
    end
  end


  def search
    @search_term = input.split(" ").join("%20").downcase
    # issue with genres like hip-hop vs hong kong pop ... space vs dash
    puts
    puts "Your search term was '#{input.capitalize}', I am searching the Spotify database. Please hold..."
    puts
    # needs an if conditional statement to check input agains pre-existing genre array

    # This chunk of code sets up the first url search instance
    first_url = "http://api.spotify.com/v1/search?q=genre:#{@search_term}&limit=50&offset=0&type=artist"
    first_url_artist_data_raw = RestClient.get(first_url)
    result = JSON.parse(first_url_artist_data_raw)
    artist_information_array = result["artists"]["items"]

    # Thiis chunk of code uses pagination (until next == null) to run through all pages, then shovels results into an array
    while result["artists"]["next"]
      artist_data_raw = RestClient.get(result["artists"]["next"])
      result = JSON.parse(artist_data_raw)
      artist_information_array += result["artists"]["items"]
    end


    puts "Found artists...sorting..."
    puts
    # This code block created the full artist name hash with popularity and follower values
    artist_information_array.each do | attribute_hash |
            each_artist_name = attribute_hash["name"]
            @@artist_hash[each_artist_name] ||= {}
            @@artist_hash[each_artist_name][:popularity] = attribute_hash["popularity"]
            @@artist_hash[each_artist_name][:followers] = attribute_hash["followers"]["total"]
    end

    puts "Thank you for your patience. Here is a list of all '#{@search_term.capitalize}' artists on Spotify:"
    puts

    # This block of code iterates over the final populated hash array, and organizes it using index + 1. Outputs list
    @@artist_hash.each_with_index do |(artist, popularity_followers_hash), index |
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
    puts "        ---Help Menu---       "
    puts "Type 'genre' for a list of genres."
    puts "Type 'search' to search by genre and popularity."
    puts "Type 'exit' to exit."
    puts "Type 'help' to view this menu again."
  end

end
