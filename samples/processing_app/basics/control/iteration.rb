# Iteration in Ruby differs from that in Processing / Java.
# Where you'd mainly use for- and while constructs in the later
# you'd be using iterators with blocks (do-end, {}) in Ruby.

def setup
  size 640, 360  
  background 102
  no_stroke

  num = 14
  
  # Draw white bars
  
  fill 255
  k = 60
  
  (num/3).times do |i|  # Loop using the "times" iterator of a number
    rect 40, k, 475, 10
    k += 20
	end
	
	# Dark grey bars
	
	fill 51
	k = 40
	
	0.upto( num-1 ) do |i|  # Loop using "upto" of a number
	  rect 405, k, 30, 10
	  k += 20
	end
	
	k = 50
	
	arr = (0...num).to_a  # Create an array with increasing numbers from a Range to
	
	arr.each do |i|  	    # use with the "each" iterator of Array
	  rect 425, k, 30, 10
	  k += 20
	end
	
	# Thin lines
	
	fill 0
	k = 45
	
	(0...num-1).step(1) do |i|  # Loop using a Range with its "step" iterator
	  rect 120, k, 40, 1
	  k += 20
	end
end
