require 'ruby-processing'

#  * Demonstrates the syntax for creating a two-dimensional (2D) array.
#  * Values in a 2D array are accessed through two index values.  
#  * 2D arrays are useful for storing images. In this example, each dot 
#  * is colored in relation to its distance from the center of the image.

class Array2d < Processing::App

  def setup
    
    distances = Array.new( width ) { Array.new( height ) } # [width][height]
	
    maxDistance = dist( width/2, height/2, width, height )
    
    0.upto( width-1 ) do |j|
    	0.upto( height-1 ) do |i|
    		dist = dist( width/2, height/2, j, i )
    		distances[j][i] = dist / maxDistance * 255
    	end
    end
    
    background 0
    
    j = 0; while j < distances.length
		i = 0; while i < distances[j].length
			stroke distances[j][i]
    		point j, i
    		i += 2
    	end
    	j += 2
    end
    
  end
  
end

Array2d.new :title => "Array 2d", :width => 200, :height => 200