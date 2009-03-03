require 'ruby-processing'

# Conditions are like questions. 
# They allow a program to decide to take one action if 
# the answer to a question is true or to do another action
# if the answer to the question is false. 
# The questions asked within a program are always logical
# or relational statements. For example, if the variable 'i' is 
# equal to zero then draw a line. 

class Conditionals1 < Processing::App

  def setup
  	
  	background 0
    
    1.upto( width / 10 ) do |i|
    
    	# If 'i' divides by 20 with no remainder draw the first line
  		# else draw the second line
    	if ( i % 2 ) == 0
    		stroke 153
    		line i*10, 40, i*10, height/2
    	else
    		stroke 102
    		line i*10, 20, i*10, 180
    	end
    end
  end
  
end

Conditionals1.new :title => "Conditionals1", :width => 200, :height => 200