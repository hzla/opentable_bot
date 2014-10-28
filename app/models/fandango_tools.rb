class FandangoTools
  @@api_key = ENV['TMS_KEY']
  @@base_uri = "http://data.tmsapi.com/v1"
  

  def initialize
 
  end

  def self.movie_recs lat, lng, start_time=nil, start_date=nil, radius=nil 
    url = "#{@@base_uri}/movies/showings?lat=#{lat}&lng=#{lng}&api_key=#{@@api_key}"

    if start_date
      url += "&startDate=#{start_date}"
    else
      url += "&startDate=#{default_start_date}"
    end
    movie_list = HTTParty.get(url).parsed_response
    theatre_grouped_movies = group_by_theatre(movie_list)
    if start_time
      movie_recommendations = pick_best_times(theatre_grouped_movies, start_time)
    else
      theatre_grouped_movies
    end
  end

  def self.all_movies
    url = "#{@@base_uri}/movies/showings?lat=#{lat}&lng=#{lng}&api_key=#{@@api_key}"
    if start_date
      url += "&startDate=#{start_date}"
    else
      url += "&startDate=#{default_start_date}"
    end
    movie_list = HTTParty.get(url).parsed_response
  end

  def self.pick_best_times theatre_grouped_movies, start_time #start_time format hh:mm 24hr, needs a lot of refactoring
    start_time_in_minutes = (start_time[0..1].to_i * 60) + (start_time[-2..-1].to_i)
    recommended_time = start_time_in_minutes + 90 # get the recommended time in minutes
    
    filtered_movies = theatre_grouped_movies.map do |theatre|
      picked_showing = {}
      name = theatre[0]
      showings = theatre[1]
      filtered_showings = showings.map do |showing|
        movie_time = showing['dateTime'][-5..-1]
        movie_time_in_minutes = (movie_time[0..1].to_i * 60) + (movie_time[-2..-1].to_i) #get the movie showingi n minutes
        if movie_time_in_minutes - recommended_time > 0 && !picked_showing[showing['title']] 
          picked_showing[showing['title']] = true
          return_showing = showing
        else
          return_showing = nil
        end #picks the first movie after the recommended time
        return_showing
      end
      [name, filtered_showings.compact] 
    end
    filtered_movies
  end

  def self.group_by_theatre movie_list
    theatres = {} #creates empty hash where theatres names are keys

    movie_list.each do |movie|
      showtimes = movie['showtimes']  
      
      showtimes.each do |showtime| #for each showing of a movie
        timestamped_movie = movie.clone #make a copy of the movie
        timestamped_movie['dateTime'] = showtime['dateTime'] #write the datetime directly onto the movie
        timestamped_movie['showtimes'] = nil #delete the extra theatre data
  
        if theatres[showtime['theatre']['name']] #if movie theatre already exists 
          theatres[showtime['theatre']['name']] << timestamped_movie #add the showing to the theatre
        else
          theatres[showtime['theatre']['name']] = [timestamped_movie] #create an empty array and add the first showing
        end
      end
    end
    theatres.to_a
  end

  def self.default_start_date
    Time.now.strftime("%Y-%m-%d")
  end

end