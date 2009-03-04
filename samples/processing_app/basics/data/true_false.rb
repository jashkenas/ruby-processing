require 'ruby-processing'

# Boolean data is one bit of information. True or false. 
# It is common to use Booleans with control statements to 
# determine the flow of a program. In this example, when the
# boolean value "x" is true, vertical black lines are drawn and when
# the boolean value "x" is false, horizontal gray lines are drawn.

# In Ruby, false and nil are "falsy" ... they are the only things
# that will fail an "if" test. Absolutely everything else passes "if".

class TrueFalse < Processing::App

  def setup
  	  background 0
  	  stroke 0
  	  
  	  (1..width).step(2) do |i|
  	    
  	    x = i < (width/2) # Evaluates to true or false, depending on i
  	    
  	    if x
  	    	stroke 255
  	    	line i, 1, i, height-1
  	    end
  	    
  	    if !x
  	    	stroke 126
  	    	line width/2, i, width-2, i
  	    end
  	      
  	  end
  end
  
end

TrueFalse.new :title => "True False", :width => 200, :height => 200