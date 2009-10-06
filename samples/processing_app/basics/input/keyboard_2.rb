require 'ruby-processing'

# Click into the window to give it focus and press the letter keys 
# to create forms in time and space. Each key has a unique identifying 
# number called it's ASCII value. These numbers can be used to position 
# shapes in space. 

class Keyboard2 < Processing::App

  def setup
    @num_chars = 26
    @key_scale = 200.0 / @num_chars-1.0
    @rect_width = width/4
    no_stroke
    background 0
  end
  
  def draw
  	if key_pressed?
  		if ('A'..'z').include? key
  			if key <= "Z"
  				@key_index = key.ord - "A".ord
  			else
  				@key_index = key.ord - "a".ord
  			end
			fill millis % 255
			begin_rect = @rect_width/2 + @key_index * @key_scale - @rect_width/2
			rect begin_rect, 0, @rect_width, height
  		end
  	end
  end
  
end

# String.ord is Ruby 1.9, so this is a little fix for R 1.8 
# to make it forward compatible and readable
unless String.method_defined? "ord"
	class String
		def ord
			self[0]
		end
	end
end

Keyboard2.new :title => "Keyboard 2", :width => 200, :height => 200