require 'ruby-processing'

# The logical operators for AND (&&) and OR (||) are used to 
# combine simple relational statements into more complex expressions.
# The NOT (!) operator is used to negate a boolean statement. 

class LogicalOperators < Processing::App

  def setup
    
  	background 126
  	
  	op = false
  	
  	(5..195).step(5) do |i|
  	
  		stroke 0
  		
  		# Logical AND
  		
  		if (i > 35) && (i < 100)
  			
  			line 5, i, 95, i
  			op = false
  		end
  		
  		stroke 76
  		
  		# Logical OR
  		
  		if (i <= 35) || (i >= 100)
  			line 105, i, 195, i
  			op = true
  		end
  		
  		
		# Testing if a boolean value is "true"
		# The expression "if op" is equivalent to "if (op == true)"
  		
  		if op
  			stroke 0
  			point width/2, i
  		end
  		
		# Testing if a boolean value is "false"
		# The expressions "unless op" or "if !op" are equivalent to "if (op == false)"
  		
  		unless op
  			stroke 255
  			point width/4, i
  		end
  		
  	end
    
  end
  
end

LogicalOperators.new :title => "Logical Operators", :width => 200, :height => 200