load_library :grafica

include_package 'grafica'

POINTS = 100

def setup
  size(500, 350)
  background(150)

  # Prepare the points for the plot
  points = GPointsArray.new(POINTS)
  
  POINTS.times do |i|
    points.add(i, 10 * noise(0.1 * i))
  end
  
  # Create a new plot and set its position on the screen
  plot = GPlot.new(self)
  plot.set_pos(25, 25)
  
  # Set the plot title and the axis labels
  plot.set_points(points)
  plot.getXAxis.setAxisLabelText("x axis")
  plot.getYAxis.setAxisLabelText("y axis")
  plot.setTitleText("A very simple example")

  # Draw it!
  plot.default_draw
end
