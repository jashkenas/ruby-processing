#
# Zoom. 
# 
# Move the cursor over the image to alter its position. Click and press
# the mouse to zoom. This program displays a series of lines with their 
# heights corresponding to a color value read from an image. 
#


attr_reader :img, :img_pixels, :sval, :nmx, :nmy, :res

def setup
  size(640, 360, P3D)
  noFill()
  stroke(255)
  @img = load_image("ystone08.jpg")
  @img_pixels = []
  @sval = 1.0
  @res = 5
  @nmx = 0
  @nmy = 0
  (0 ... img.height).each do |i|
    inner = []
    (0 ... img.width).each do |j|
      inner << img.get(j, i)
    end
    img_pixels << inner
  end  
end

def draw
  background(0)

  @nmx += (mouse_x - nmx) / 20 
  @nmy += (mouse_y - nmy) / 20 

  if(mouse_pressed?)  
    @sval += 0.005 
  else 
    @sval -= 0.01 
  end

  @sval = constrain(sval, 1.0, 2.0)
  translate(width/2 + nmx * sval-100, height/2 + nmy*sval - 100, -50)
  scale(sval)
  rotate_z(PI / 9 - sval + 1.0)
  rotate_x(PI / sval / 8 - 0.125)
  rotate_y(sval / 8 - 0.125)
  translate(-width/2, -height/2, 0)
  (0 ... img.height).step(res) do |i|
    (0 ... img.width).step(res) do |j|
      rr = red(img_pixels[j][i]) 
      gg = green(img_pixels[j][i])
      bb = blue(img_pixels[j][i])
      tt = rr + gg + bb
      stroke(rr, gg, gg)
      line(i, j, tt / 10 - 20, i, j, tt / 10 )
    end
  end
end






