# Ignore Styles. 
# Illustration by George Brower. 
# 
# Shapes are loaded with style information that tells them how
# to draw (the color, stroke weight, etc.) The disableStyle() 
# method of PShape turns off this information. The enableStyle()
# method turns it back on.

class DisableStyle < Processing::App

  def setup
    
    size 640, 360
    smooth
    
    @bot = load_shape "bot1.svg"
    
    no_loop
  end
  
  def draw
  	
  	background 102
  	
  	@bot.disable_style
  	fill 0, 102, 153
  	stroke 255
  	shape @bot, 20, 25
  	
  	@bot.enable_style
  	shape @bot, 320, 25
  end
  
end

DisableStyle.new :title => "Disable Style"