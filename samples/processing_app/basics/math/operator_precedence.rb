# Operator Precedence
# 
# If you don't explicitly state the order in which
# an expression is evaluated, they are evaluated based
# on the operator precedence. For example, in the statement
# "4+2*8", the 2 will first be multiplied by 8 and then the result will
# be added to 4. This is because the "*" has a higher precedence
# than the "+". To avoid ambiguity in reading the program, 
# it is recommended that is statement is written as "4+(2*8)".
# The order of evaluation can be controlled through placement of
# parenthesis in the code. A table of operator precedence follows below.
 
# The highest precedence is at the top of the list and 
# the lowest is at the bottom.
# Multiplicative: * / %
# Additive: + -
# Relational: < > <= >=
# Equality: == !=
# Logical AND: &&
# Logical OR: ||
# Assignment: = += -= *= /= %=

class OperatorPrecedence < Processing::App

  def setup
    
    size 200, 200
    
    background 51
    
    no_fill
    stroke 204
    
    (0...(width-20)).step( 4 ) { |i|
    
  		# The 30 is added to 70 and then evaluated
		# if it is greater than the current value of "i"
		# For clarity, write as "if i > (30 + 70))"
		
    	line i, 0, i, 50 if i > 30 + 70
    }
    
    stroke 255
    
    # The 2 is multiplied by the 8 and the result is added to the 4
	# For clarity, write as "rect 4 + (2 * 8), 52, 90, 48"
	
    rect( 4 + 2 * 8, 52, 90, 48 )
    rect( (4 + 2) * 8, 100, 90, 49 )
    
    stroke 153
    
    (0...width).step( 2 ) { |i|
    
  		# The relational statements are evaluated 
  		# first, and then the logical AND statements and 
  		# finally the logical OR. For clarity, write as:
  		# "if ((i > 20) && (i < 50)) || ((i > 100) && (i < 180))"
    
    	line i, 151, i, height-1 if i > 20 && i < 50 || i > 100 && i < width-20
    }
  end
  
  def draw
  
  end
  
end

OperatorPrecedence.new :title => "Operator Precedence"