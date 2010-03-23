# Letters. 
# 
# Draws letters to the screen. This requires loading a font, 
# setting the font, and then drawing the letters.

class Letters < Processing::App

  def setup
    
    size 200, 200
    
    smooth
    
    @font = load_font "CourierNew36.vlw" # you need the Processing IDE to
					 # generate .vlw fonts ..
    text_font @font, 32
    text_align CENTER
    
  end
  
  def draw
  
    background 0
  	
  	translate 24, 32
  	
  	x, y = 0.0, 0.0
  	gap = 30
  	
  	letters = ("A".."Z").to_a + ("0".."9").to_a # ranges -> arrays -> joined!
  	
  	letters.each do |letter|
  	
  		fill 255
  		fill 204, 204, 0 if letter =~ /[AEIOU]/
  		fill 153 if letter =~ /[0-9]/
  		fill 255, 100, 0 if key_pressed? && (letter.downcase.eql? key)
  	
  		text letter, x, y
  		
  		x += gap
  		
  		if x > width - 30
  			x = 0
  			y += gap
  		end
  	end
  end
  
end

Letters.new :title => "Letters"