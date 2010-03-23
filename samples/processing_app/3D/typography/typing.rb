# Typing (Excerpt from the piece Textension) 
# by Josh Nimoy.  
# 
# Click in the window to give it focus.
# Type to add letters and press backspace or delete to remove them.

class Typing < Processing::App

  def setup
  
  	size 640, 360, P3D
  	
  	@left_margin = 10
  	@right_margin = 20
  	@buf = ""
  	
  	text_font load_font( "Univers45.vlw" ), 25
    
  end
  
  def draw
  
  	background 176
  	
  	if (millis % 500) < 200
	  	no_fill
  	else
  		fill 255
  		stroke 0
  	end
  	
  	r_pos = text_width( @buf ) + @left_margin
  	rect r_pos+1, 19, 10, 21
  	
  	fill 0
  	
  	push_matrix
  	
  		translate r_pos, 35
  		
  		if @buf.length > 0
			(0...@buf.length).each { |i|
				k = @buf[@buf.length - 1 - i]
				translate -text_width( k ), 0
				rotate_y -text_width( k ) / 70.0
				rotate_x text_width( k ) / 70.0
				scale 1.1
				text k, 0, 0
			}
		end
		
  	pop_matrix
  	
  end
  
  def key_pressed
  
  	if key != CODED && 
  	   text_width( @buf + key ) + @left_margin < width - @right_margin && 
  	   keyCode != BACKSPACE && 
  	   keyCode != DELETE
  		@buf += key
  	end
  	
  	if keyCode == BACKSPACE || keyCode == DELETE
  		if @buf.length > 1
		  	@buf = @buf[0..(@buf.length-2)]
	  	else
	  		@buf = ""
	  	end
  	end
  	
  end
  
end

Typing.new :title => "Typing"