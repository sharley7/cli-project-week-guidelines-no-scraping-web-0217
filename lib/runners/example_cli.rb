require 'pry'
class ExampleCLI

attr_accessor :input, :search, :artist_name, :artist_data

 @@pop_arr = []
 @@artist_hash = {}

# Started here - Decided to start my day easy and make the welcome screen look more welcoming, ascii logo added, star lines, exit message also added
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
# * lines outputed to frame the welcome message
    puts "*" * 60
    puts "                  Welcome to SPACIAL"
# Figured out S.P.A.C.I.A.L. was a nice sounding anagram for what our app does - not commited to it, can definitely change
    puts "  The Spotify Popular Artist CLI Interface Application."
    puts "Search for artists based on genre by popularity & followers!"
# More stars and formatting in the above lines
    puts "*" * 60
    puts

    run
  end

  def get_user_input
    gets.chomp.strip
  end

# added in an empty puts line for spacing so it's easier to read on user side
  def run
   help
   puts
   input = ""

# So I had difficulty understanding case/when - for my benefit, I changed it to while and if... But totally open to using Case/When if you'd like too. Just not sure how to implement from here
# added in more empty puts' for spacing - doesn't have to be there, can delete for whatever reason, (looks to oclunky on pack end, spacing doesnt look good... not married to it)
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
# here's where I want to create a new instance method, just so things look cleaner in the end.
# I was thinking ideally it would puts out the help menu and add the new options available
# i.e. (sort by popularity or followers/out put list with those stats? It's up to us to decide)
        after_search_query

        @input = get_user_input
# Did not get into popularity filter
        popularity_filter

        return_names
      elsif input == "genre"
        genre
# Added in edge case output if user enters invalid command
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

# after search query - to be run after the search output
  def after_search_query
    puts
    puts "Wow, what a great list of #{@search_term.capitalize} artists"
    puts
    puts "Now you have new search terms! Sory by 'popularity' and 'followers'."
    puts
    puts "Type 'popularity' to see popularity options"
    puts "Type 'followers' to see followers options"
    puts "Type 'help to see the help menu'"
    puts

# Runs through the while/if conditional input menu - I think this could be refactored
# Can only input help or exit at the moment, missing popularity and followers
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

# This is the biggest change I followed the lecture steven made to a T
# included the search loop entirely in the cli directory
# now that this is working, it can be refactored to be included in another class
# so that our code looks cleaner
  def search
    @search_term = input.split(" ").join("%20").downcase
# Ran into some issues here with genres like hip-hop & hong kong pop or Honky Tonk
# Not sure if we need to email a deveoper but if you try obscure genres
# Using our app or messing around in a browser url, there's empty returns
# My hunch was that some genres have spaces, and some use dashes to seperate words
# But so far I can't figure out a solution - Might have to limit genre choice somehow
# If it's out of our hands
    puts
    puts "Your search term was '#{input.capitalize}', I am searching the Spotify database. Please hold..."
    puts

# Ideally still needs an if conditional statement to check input agains pre-existing genre array

# ***
# This chunk of code sets up the first url search instance
    first_url = "http://api.spotify.com/v1/search?q=genre:#{@search_term}&limit=50&offset=0&type=artist"
    first_url_artist_data_raw = RestClient.get(first_url)
    result = JSON.parse(first_url_artist_data_raw)
    artist_information_array = result["artists"]["items"]
# ***

# ***
# This chunk of code uses pagination (until next == null) to run through all pages
# Starts with original search URL from above, the loads next page and shovels results into an array
# Will repeat loading next page until next == nul
    while result["artists"]["next"]
      artist_data_raw = RestClient.get(result["artists"]["next"])
      result = JSON.parse(artist_data_raw)
      artist_information_array += result["artists"]["items"]
    end
# ***

# Barely necessary load output string, our app is surprisingly fast... so far
    puts "Found artists...sorting..."
    puts

# ***
# This code block creates the full artist name hash with popularity and follower values
# Feel free to try binding.pry here
    artist_information_array.each do | attribute_hash |
            each_artist_name = attribute_hash["name"]
            @@artist_hash[each_artist_name] ||= {}
            @@artist_hash[each_artist_name][:popularity] = attribute_hash["popularity"]
            @@artist_hash[each_artist_name][:followers] = attribute_hash["followers"]["total"]
            # binding.pry
    end
# ***

    puts "Thank you for your patience. Here is a list of all '#{@search_term.capitalize}' artists on Spotify:"
    puts

# ***
# This block of code iterates over the final populated hash, (@@artist_hash), and organizes it using index + 1.
# Outputs full list
    @@artist_hash.each_with_index do |(artist, popularity_followers_hash), index |
      puts " #{index + 1}. #{artist}"
    end
  end
# ***

# I did not touch the below popularity filter since _ spent most of my time re-formatting the above
# I think variables will have to be changed here based on the above
# I tried to make things more specific so variables are easy to understand at a glance
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

# Just realized this was here. Looks like I can refactor the above
# loop/output into this handy separate method
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
