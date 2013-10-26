require 'csv'
load_library :grafica
include_package 'grafica'

MONTH_NAMES = %w(January February March April May June July August September October November December)
DAYS_PER_MONTH = [31,28,31,30,31,30,31,31,30,31,30,31]
DAYS_PER_MONTH_LEAP_YEAR = [31,29,31,30,31,30,31,31,30,31,30,31]

attr_reader :plot, :points_oktoberfest, :points_elections

def setup
  size(800, 400)
  
  # Load the Oktoberfest vs. Bundestagswahl (German elections day) Google 
  # search history file (obtained from the Google trends page). 
  # The csv file has the following format: 
  # year,month,day,oktoberfest,bundestagswahl
  # 2004,0,1,5,1
  # ...
  @points_oktoberfest = GPointsArray.new
  @points_elections = GPointsArray.new
  
  
  data = CSV.read("data/OktoberfestVSGermanElections.csv", :headers => true).map{|row| row.to_hash}
  data.each do |row|
    # You access the values via their column name (set by using headers option above)
    year = row["year"].to_i
    month = row["month"].to_i
    day = row["day"].to_i
    date = get_exact_date(year, month, day)
    oktoberfest_count = row["oktoberfest"].to_i
    elections_count = row["bundestagswahl"].to_i
    points_oktoberfest.add(date, oktoberfest_count, MONTH_NAMES[month])
    points_elections.add(date, elections_count, MONTH_NAMES[month])
  end
  # Create the plot
  @plot = GPlot.new(self)
  plot.set_dim(700, 300)
  plot.set_title_text("Oktoberfest vs. Bundestagwahl Google search history")
  plot.getXAxis.set_axis_label_text("Year")
  plot.getYAxis.set_axis_label_text("Google normalized searches")
  plot.getXAxis.setNTicks(10)
  plot.set_points(points_oktoberfest)
  plot.set_line_color(color(100, 100, 100))
  plot.add_layer("German elections day", points_elections)
  plot.get_layer("German elections day").set_line_color(color(255, 100, 255))
  plot.activate_point_labels
end

def draw
  background(255)
  
  # Draw the plot  
  plot.begin_draw
  plot.draw_box
  plot.drawXAxis
  plot.drawYAxis
  plot.draw_title
  plot.draw_grid_lines(GPlot::VERTICAL)
  plot.draw_filled_contours(GPlot::HORIZONTAL, 0)
  plot.draw_legend(%w(Oktoberfest Bundestagswahl), 
    [0.07,0.22], 
    [0.92, 0.92])
  plot.draw_labels
  plot.end_draw
end 

def get_exact_date(year, month, day)
  leap_year = false
  if (year % 400 == 0) 
    leap_year = true
  elsif (year % 100 == 0) 
    leap_year = false
  elsif (year % 4 == 0) 
    leap_year = true
  end
  if leap_year
    return year + (month + (day - 1) / DAYS_PER_MONTH_LEAP_YEAR[month]) / 12.0
  else
    return year + (month + (day - 1)/ DAYS_PER_MONTH[month]) / 12.0
  end
end

