# Words. 
# 
# The text() function is used for writing words to the screen. 

class Words < Processing::App

  def setup
    
    size 200, 200
    
    @x = 30
    
    @font = load_font "Ziggurat-HTF-Black-32.vlw" # generate with Processing IDE
    
    text_font @font, 32
    
    no_loop
  end
  
  def draw
    
    background 102
  
  	fill 0
  	text "ichi", @x, 60
  	fill 51
  	text "ni", @x, 95
  	fill 204
  	text "san", @x, 130
  	fill 255
  	text "shi", @x, 165
  	
  end
  
end

Words.new :title => "Words"