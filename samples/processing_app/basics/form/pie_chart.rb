require 'ruby-processing'

# Pie Chart  
# By Ira Greenberg 
# 
# Uses the arc() function to generate a pie chart from the data
# stored in an array.

class PieChart < Processing::App

  def setup
    background 100
    smooth
    no_stroke
    
    diameter = 150
    angles = [30, 10, 45, 35 ,60, 38, 75, 67]
    last_angle = 0.0
    
    angles.each do |angle|
    	fill angle * 3.0
    	arc width/2, height/2, 	 						    # center x, y
    		diameter, diameter,  						      # width, height
    		last_angle, last_angle + radians(angle)	# angles from, to
    	last_angle += radians(angle)
    end
  end
  
end

PieChart.new :title => "Pie Chart", :width => 200, :height => 200