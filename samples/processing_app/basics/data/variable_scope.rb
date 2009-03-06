require 'ruby-processing'

# Variables may either have a global or local "scope". 
# For example, variables declared within either the
# setup or draw functions may be only used in these
# functions. Global variables, variables declared outside
# of setup and draw, may be used anywhere within the program.
# If a local variable is declared with the same name as a
# global variable, the program will use the local variable to make 
# its calculations within the current scope. Variables may be localized
# within classes, functions, and iterative statements.

# Please note that there are some changes on variable scope inside blocks
# between Ruby versions 1.8 and 1.9.

class VariableScope < Processing::App

  def setup
  		background 51
  		stroke 255
  		no_loop
  		
  		@a = 20 # Use "@" before the name to create an instance variable ("@a"), 
  				    # which will be available anywhere inside this instance of "VariableScope".
  end
  
  def draw
  		# Draw a line using the instance variable "a", 
  		# as returned by its getter function below
  		line a, 0, a, height
  		
  		# Create a new variable "a" local to the block (do-end)
  		(50..80).step(2) do |a|
  			line a, 0, a, height
  		end
  		
  		# Create a new variable "a" local to the draw method
  		a = 100
  		line a, 0, a, height
  		
  		# Make a call to the custom function draw_another_line
  		draw_another_line
  		
  		# Make a call to the custom function draw_yet_another_line
  		draw_yet_another_line
  end
  
  def draw_another_line
  		# Create a new variable "a" local to this method
  		a = 185
  		
  		# Draw a line using the local variable "a"
  		line a, 0, a, height
  end
  
  def draw_yet_another_line
  		# Because no new local variable "a" is set, this line draws using the 
  		# instance variable "a" (returned by its getter function) which was 
  		# set to the value 20 in setup.
  		line a+2, 0, a+2, height
  end
  
  # This is a "getter" function, it returns the value of the instance variable "a"
  def a
  	@a
  end
  
  # Ruby can add that getter function for you automatically:
  # attr_reader :a
  
  # And this would create a setter which will allow you to set "a" to a value ( "a = 123" )
  # without using that "@" sign all the time:
  # attr_writer :a
  
  # Or you could just have Ruby add both at once with:
  # attr_accessor :a
  
end

VariableScope.new :title => "Variable Scope", :width => 200, :height => 200