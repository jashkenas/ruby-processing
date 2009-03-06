require 'ruby-processing'

#  * An array is a list of data. Each piece of data in an array 
#  * is identified by an index number representing its position in 
#  * the array. Arrays are zero based, which means that the first 
#  * element in the array is [0], the second element is [1], and so on. 
#  * In this example, an array named "coswav" is created and
#  * filled with the cosine values. This data is displayed three 
#  * separate ways on the screen.  

class ArrayExample < Processing::App

  def setup
    
    coswave = []
    
    0.upto( width ) do |i|
    	amount = map i, 0, width, 0, PI
    	coswave[i] = cos( amount ).abs
    end
    
    0.upto( width ) do |i|
    	stroke( coswave[i] * 255 )
    	line i, 0, i, height/3
    end
    
    0.upto( width ) do |i|
    	stroke( coswave[i] * 255 / 4 )
    	line i, height/3, i, height/3*2
    end
    
    0.upto( width ) do |i|
    	stroke( 255 - coswave[i] * 255 )
    	line i, height/3*2, i, height
    end
    
  end
  
end

ArrayExample.new :title => "Array Example", :width => 200, :height => 200