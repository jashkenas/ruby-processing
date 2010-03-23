# Multiple constructors in Processing / Java
# 
# A class can have multiple constructors that assign the fields in different ways. 
# Sometimes it's beneficial to specify every aspect of an object's data by assigning 
# parameters to the fields, but other times it might be appropriate to define only 
# one or a few.

# fjenett, 2010-03-13:
#
# Ruby constructors are called "initialize" no matter what the name of the class is.
#
# In Ruby you can not have multiple methods with the same name although they have different
# parameters. In fact the last definition of a method will override all previous ones.
# But there are two ways to define methods with variable parameters. One is to give the 
# parameters a default value, the second is to use the catch-all asterix:

# def my_method1 ( a, b = "2" ) # can be called with one or two arguments
# end

# def my_method2 ( *args ) # can be called with any number of arguments, args is an array
# end

class MultipleConstructors < Processing::App

  def setup
  	
  	size 200, 200
  	
  	background 204
  	smooth
  	no_loop
  	
  	sp1 = Spot.new
  	sp2 = Spot.new 122, 100, 40
  	
  	sp1.display
  	sp2.display
  end
  
  def draw
  
  end
  
  # vvv CLASS SPOT
  
  class Spot
  
  	attr_accessor :x, :y, :radius
  	
  	def initialize ( x = 66, y = 100, r = 16 ) # can be called with 0 to 3 arguments
  	
  		@x, @y, @radius = x, y, r
  	end
  	
  	def display
  	
  		ellipse @x, @y, @radius*2, @radius*2
  	end
  
  end
  
  # ^^^ CLASS SPOT
  
end

MultipleConstructors.new :title => "Multiple Constructors"