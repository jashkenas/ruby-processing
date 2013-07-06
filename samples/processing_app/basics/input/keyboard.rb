# Click into the window to give it focus and press the letter keys 
# to create forms in time and space. Each key has a unique identifying 
# number called it's ASCII value. These numbers can be used to position 
# shapes in space. 


def setup
  size 640, 360
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
    begin_rect = map(@key_index, 0, 25, 0, width - @rect_width)
    rect begin_rect, 0, @rect_width, height
  end
end
	
