require 'ruby-processing'

# We extend the language of conditionals by adding the 
# keyword "elsif". This allows conditionals to ask 
# two or more sequential questions, each with a different
# action. 

class Conditionals2 < Processing::App

  def setup
  
  	background 0
  	
  	1.upto( width / 2 ) do |i|
  	
  		# If 'i' divides by 10 with no remainder 
  		# draw the first line .. 
  		# else if 'i' devides by 5 with no remainder 
  		# draw second line else draw third
  		
  		if (i % 10) == 0
  		
  			stroke 255
  			line i*2, 40, i*2, height/2
  		
  		elsif (i % 5) == 0
  		
  			stroke 153
  			line i*2, 20, i*2, 180
  			
  		else
  		
  			stroke 102
  			line i*2, height/2, i*2, height-40
  			
  		end
  		
  	end
    
  end
  
end

Conditionals2.new :title => "Conditionals2", :width => 200, :height => 200