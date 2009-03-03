require 'ruby-processing'

# Variables are used for storing values. In this example, changing 
# the values of variables 'a' and 'b' significantly changes the composition. 

class Variables < Processing::App

  def setup
    	background 0
    	stroke 153
    	
    	a = 20	# Change these!
    	b = 50
    	
    	c = a * 8
    	d = a * 9
    	e = b - a
    	f = b * 2
    	g = f + e
    	
    	line a, f, b, g
    	line b, e, b, g
    	line b, e, d, c
    	line a, e, d-e, c
  end
  
end

Variables.new :title => "Variables", :width => 200, :height => 200