require 'rest-client'
require 'pry'


class Spotify_Top_Tracks

  attr_accessor :most 

  BASE_URL = "http://charts.spotify.com/api/tracks/"

  def run
    initial_menu
    # Say please choose either most streamed or most viral (INITIAL MENU)
    @answer == "most streamed" ? streamed : viral
    puts "============================================================================================"
    puts "How many songs would you like to be listed (1-50)?"
    @num_songs = gets.chomp.to_i
    puts "============================================================================================"
    puts "Below are the #{@most.gsub('_',' ')} songs in your selected region:"
    parse_url


  end 

  def initial_menu
    puts "Welcome to a Spotify API parser that allows you to list the top tracks in a given category!"
    puts "These prompts will help us build a unique url that will return the relevant Spotify API data."
    puts "============================================================================================"
    puts "1. Would you like data for the most streamed or most viral tracks?"
    @answer = gets.chomp.downcase
    # put in error handling if neither stream or viral
  end

  def streamed
    @most = "most_streamed"
    get_country
    get_weekly_daily 
  end

  def viral
    @most = "most_viral"
    get_country
    @time_interval = "weekly"
    
  end

  def get_country
    @countries = ["ad","ar","at","au","be","bg","bo","br","ca","ch","cl","co","cr","cy","cz","de","dk","do","ec","ee","es","fi","fr","gb","gr","gt","hk","hn","hu","ie","is","it","li","lt","lu","lv","mt","mx","my","ni","nl","no","nz","pa","pe","ph","pl","pt","py","se","sg","sk","sv","tr","tw","us","uy","global"]
    puts "============================================================================================"
    puts "2. Please select a country (or global for worldwide) from the list below:"
    @countries.each.with_index(1) {|country, index| puts "#{index}. #{country.upcase}"}
    @region = gets.chomp.downcase
    #error handling here
  end

  def get_weekly_daily
    puts "============================================================================================"
    puts "3. Would you like the most recent weekly or daily results?"
    @time_interval = gets.chomp.downcase
  end

  def parse_url
    spotify_json = RestClient.get("#{BASE_URL}#{@most}/#{@region}/#{@time_interval}/latest")
    parsed = JSON.parse(spotify_json)
      parsed["tracks"].first(@num_songs).each.with_index(1) do |track, index|
        puts "#{index}. #{track['track_name']} by #{track['artist_name']}."
      end
  end



end

test = Spotify_Top_Tracks.new
test.run


