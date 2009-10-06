require 'ruby-processing'

# Modified from code by Martin. 
# Original 'Color Typewriter' concept by John Maeda. 
# 
# Click on the window to give it focus and press the letter keys to type colors. 
# The keyboard function keyPressed() is called whenever
# a key is pressed. keyReleased() is another keyboard
# function that is called when a key is released.

class KeyboardFunctions < Processing::App

  def setup
  	@num_chars = 26
  	@letter_width, @letter_height = 10, 10  	
  	@x = -@letter_width
  	@y = 0
  	
  	no_stroke
    color_mode RGB, @num_chars
    background @num_chars/2
    
    # Set a gray value for each key
    @colors = []
    @num_chars.times { |i| @colors[i] = color i }
  end
  
  def draw
  	if new_letter?
  		if upcase?
  			fill (key.ord - "A".ord).abs % 255
  			rect @x, @y, @letter_width, @letter_height*2
  		else
  			# clear with letter space with background color
  			fill @num_chars/2
  			rect @x, @y, 			    @letter_width, @letter_height
  			
  			fill (key.ord - "a".ord).abs % 255
  			rect @x, @y+@letter_height, @letter_width, @letter_height
  		end
  		@new_letter = false
  	end
  end
  
  def new_letter?
  	@new_letter
  end
  
  def upcase?
  	@upcase
  end
  
  def key_pressed
  	if ('A'..'z').include? key
  		@upcase = key <= "Z"
  		@new_letter = true
  		
  		# Update the "letter" position and 
    	# wrap horizontally and vertically
    	@y += (@letter_height*2) if @x + @letter_width >= width
    	@y = @y % height
    	@x += @letter_width
    	@x = @x % width
  	end
  end
  
end

# A fix for Ruby 1.8 that adds String.ord of Ruby 1.9
class String
	unless method_defined? "ord"
		def ord
			self[0] # return character code point of first character
		end
	end
end

KeyboardFunctions.new :title => "Keyboard Functions", :width => 200, :height => 200