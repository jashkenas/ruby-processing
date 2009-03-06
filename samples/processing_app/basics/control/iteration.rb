require 'ruby-processing'

# Iteration in Ruby differs from that in Processing / Java.
# Where you'd mainly use for- and while constructs in the later
# you'd be using iterators with blocks (do-end, {}) in Ruby.

class Iteration < Processing::App

  def setup
  	background 102
  	no_stroke
    
  	xpos1 = 100
	  xpos2 = 118 
	  count = 0
	  timey = 0
	  num = 12
	  
	  # Draw white bars
	  
	  fill 255
	  k = 60
	  
	  (num/3).times do |i|  # Loop using the "times" iterator of a number
	  	rect 25, k, 155, 5
	  	k += 10
	  end
	  
	  # Dark grey bars
	  
	  fill 51
	  k = 40
	  
	  0.upto( num-1 ) do |i|  # Loop using "upto" of a number
	  	rect 105, k, 30, 5
	  	k += 10
	  end
	  
	  k = 15
	  
	  arr = (0...num).to_a  # Create an array with increasing numbers from a Range to
	  
	  arr.each do |i|  	    # use with the "each" iterator of Array
	  	rect 125, k, 30, 5
	  	k += 10
	  end
	  
	  # Thin lines
	  
	  fill 0
	  k = 42
	  
	  (0...num-1).step(1) do |i|  # Loop using a Range with its "step" iterator
	  	rect 36, k, 20, 1
	  	k += 10
	  end
  end
  
end

Iteration.new :title => "Iteration", :width => 200, :height => 200