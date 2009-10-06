require 'ruby-processing'

# Click into the window to give it focus and press the letter keys 
# to create forms in time and space. Each key has a unique identifying 
# number called it's ASCII value. These numbers can be used to position 
# shapes in space. 

class Keyboard < Processing::App

  def setup
    @num_chars = 26
    @key_scale = 200.0 / @num_chars-1.0
    @rect_width = width/4
    
    no_stroke
    background 0
  end
  
  def draw
  	if key_pressed? && ('A'..'z').include?(key)
  	  @key_index = key.ord - (key <= 'Z' ? 'A'.ord : 'a'.ord)
			fill millis % 255
			begin_rect = @rect_width/2 + @key_index * @key_scale - @rect_width/2
			rect begin_rect, 0, @rect_width, height
  	end
  end
  
end

Keyboard.new :title => "Keyboard", :width => 200, :height => 200