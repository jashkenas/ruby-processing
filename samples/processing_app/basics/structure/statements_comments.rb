# Statements and Comments. 
# 
# Statements are the elements that make up programs.
# In Ruby you can end statements with a semi-colon ";" but you don't have to.
#
# Comments are used for making notes to help people better understand programs. 
# A comment begins with a "#" in Ruby. 

class StatementsComments < Processing::App

  def setup
    
	# The size function is a statement that tells the computer 
	# how large to make the window.
	# Each function statement has zero or more parameters. 
	# Parameters are data passed into the function
	# and used as values for specifying what the computer will do.
	size 200, 200
	
	# The background function is a statement that tells the computer
	# which color to make the background of the window 
	background 102
    
  end
  
  def draw
  
  end
  
end

StatementsComments.new :title => "Statements Comments"