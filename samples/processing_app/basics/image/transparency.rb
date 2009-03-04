require 'ruby-processing'

#  Move the pointer left and right across the image to change
#  its position. This program overlays one image over another 
#  by modifying the alpha value of the image with the tint() function. 

class Transparency < Processing::App

  def setup
    @a = load_image "construct.jpg"
    @b = load_image "wash.jpg"
    @offset = 0.0
    
    frame_rate 60
  end
  
  def draw
  	image @a, 0, 0
  	offset_target = map( mouse_x, 0, width, -@b.width/2 - width/2, 0 )
  	@offset += (offset_target - @offset) * 0.05
  	tint 255, 153
  	image @b, @offset, 20
  end
  
end

Transparency.new :title => "Transparency", :width => 200, :height => 200