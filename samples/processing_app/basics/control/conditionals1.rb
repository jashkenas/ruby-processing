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
    	# If 'i' is even then draw the first line otherwise draw the second line
  		i.even? ? draw_short(i) : draw_long(i)
    end
  end
  
  def draw_short(i)
    stroke 153
    line i*10, 40, i*10, height/2
  end
  	
  def draw_long(i)
    stroke 102
    line i*10, 20, i*10, 180
  end
  
end

# Ruby allows us to extend base classes, such as numbers, with
# methods of our choosing. In this case we'll add methods that tell
# you whether a given integer is even or odd.

class Fixnum
  
  def even?
    self % 2 == 0
  end
  
  def odd?
    !even?
  end
  
end
  

Conditionals1.new :title => "Conditionals1", :width => 200, :height => 200