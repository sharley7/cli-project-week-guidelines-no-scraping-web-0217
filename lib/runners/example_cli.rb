require 'pry'
class ExampleCLI

attr_accessor :input, :search, :artist_name, :artist_data

 @@popularity_array = []
 @@artist_hash = {}
 @@simplified_genres = ['Blues', 'Classical','Country','Electronic','Hip Hop','Industrial','Jazz','Pop','R&B','Rock','World']

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
    puts "    Search for artists based on genre by popularity!"
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


     input = get_user_input

      if input == "help"
        help
        puts
        run
      elsif input == "exit"
        puts
        puts "Thank you for using SPACIAL. See you next time!"
        puts

        exit
      elsif input == "search"
        puts
        puts "Enter a genre:"
        puts

        @input = get_user_input.downcase
          if @@simplified_genres.include?(@input.capitalize)

            search

            after_search_query

            popularity_filter

            puts
            puts "Wow! Your list of #{@search_term} artists is now sorted!"
            puts
            puts
            puts "If you would like to start again, enter 'restart'"
            puts "If you would like to exit, enter 'exit'"
            puts

            @input = get_user_input

            if @input == "restart"
              @@artist_hash.clear
              run
            elsif @input == "exit"
              puts
              puts "Thank you for using SPACIAL. See you next time!"
              puts

              exit
            end

          else
            puts
            puts "That doesn't seem to be a genre in our system"
            puts "Check searchable genres by entering 'genre'"
            puts
          end

          @input = get_user_input

          if @input == 'genre'
            list_genres_method

            run
          end

          # if @input == 'popularity'
          #   popularity_filter
          #
          #   puts "Wow! What a great sorted list of #{@search_term} artists!"
          #   puts
          #   puts "If you would like to start again, enter 'restart'"
          #   puts "If you would like to exit, enter 'exit'"
          #
          #   @input = get_user_input
          #
          #   if @input == "restart"
          #     run
          #   elsif @input == "exit"
          #     puts
          #     puts "Thank you for using SPACIAL. See you next time!"
          #     puts
          #
          #     exit
          #   end
          #
          #
          # end

        elsif input == "genre"
          list_genres_method

          run
        else
          puts
          puts "Oops! It looks like '#{input}' is not a valid command."
          puts

          help
        end
  end

  def list_genres_method
    puts
    puts "Here is a list of searchable genres"
    puts
    puts "*" * 60
    puts @@simplified_genres.join(", ")
    puts "*" * 60
    puts
  end

  def input
    @input
  end

# after search query - to be run after the search output
  def after_search_query
    puts
    puts "Wow! What a great list of #{@search_term.capitalize} artists!"

  end

  def search
    @search_term = input.split(" ").join("%20").downcase

    puts
    puts "Your search term was '#{input.capitalize}', I am searching the Spotify database. Please hold..."
    puts

    first_url = "http://api.spotify.com/v1/search?q=genre:#{@search_term}&limit=50&offset=0&type=artist"
    first_url_artist_data_raw = RestClient.get(first_url)
    result = JSON.parse(first_url_artist_data_raw)
    artist_information_array = result["artists"]["items"]

    while result["artists"]["next"]
      artist_data_raw = RestClient.get(result["artists"]["next"])
      result = JSON.parse(artist_data_raw)
      artist_information_array += result["artists"]["items"]
    end

    puts "Found artists...sorting..."
    puts


    artist_information_array.each do | attribute_hash |
            each_artist_name = attribute_hash["name"]
            @@artist_hash[each_artist_name] ||= {}
            @@artist_hash[each_artist_name][:popularity] = attribute_hash["popularity"]
            @@artist_hash[each_artist_name][:followers] = attribute_hash["followers"]["total"]
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
  puts
  puts "Artist popularity is measured from 1-100. Please enter a popularity"
  puts "     Please separate your numbers by a dash ('i.e. 40-80')"
  puts "Output will demonstrate popularity metric and follower number"
  puts
    @input = get_user_input

    input_array = input.strip.split("-")

    if input_array.all? { |num_input| user_num = Integer(num_input) rescue false }
      popularity_input_one = input_array[0].to_i
      popularity_input_two = input_array[1].to_i
      #Input is a string, so has to be change to an integer
      most_popular = sort_hash_by_popularity.last[1][:popularity]
      least_popular = sort_hash_by_popularity.first[1][:popularity]

      if most_popular < popularity_input_one || least_popular > popularity_input_two
        puts
        puts "Sorry! that search is out of range. Please try again"
        popularity_filter

      else
        puts
        puts "Returning all artists with a popularity between #{popularity_input_one} and #{popularity_input_two}"
        puts
        puts

        sort_hash_by_popularity.each do | artist, popularity_followers_hash |
          popularity_followers_hash.each do |attribute, num|
            if attribute == :popularity
              if num >= popularity_input_one && num <= popularity_input_two
                puts "#{artist}: #{popularity_followers_hash.to_s.delete("{}:=").gsub!(/[>]/, '= ')}"
                puts
              end
            end
          end
        end
      end

    else
      puts
      puts "Error: Please enter an number"

      popularity_filter
    end
    # input.gsub!(/[\s, :><+=]/, '-')
 end

   def sort_hash_by_popularity
     @@artist_hash.sort_by do | artist, popularity_followers_hash|
       popularity_followers_hash[:popularity]
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
