#
# Scrollbar. 
# 
# Move the scrollbars left and right to change the positions of the images. 
#


attr_reader :hs1, :hs2, :img1, :img2  

def setup
  size(640, 360)
  no_stroke
  
  @hs1 = HScrollbar.new(0, height/2-8, width, 16, 16)
  @hs2 = HScrollbar.new(0, height/2+8, width, 16, 16)
  
  # Load images
  @img1 = loadImage("seedTop.jpg")
  @img2 = loadImage("seedBottom.jpg")
end

def draw
  background(255)
  
  # Get the position of the img1 scrollbar
  # and convert to a value to display the img1 image 
  img1Pos = hs1.get_pos-width / 2
  fill(255)
  image(img1, width / 2-img1.width / 2 + img1Pos * 1.5, 0)
  
  # Get the position of the img2 scrollbar
  # and convert to a value to display the img2 image
  img2Pos = hs2.get_pos-width / 2
  fill(255)
  image(img2, width / 2 - img2.width / 2 + img2Pos * 1.5, height / 2) 
  hs1.update
  hs2.update
  hs1.display
  hs2.display  
  stroke(0)
  line(0, height / 2, width, height / 2)
end


class HScrollbar

  attr_reader :swidth, :sheight, :xpos, :ypos, :spos, :newspos
  attr_reader :spos_max, :spos_min, :loose, :over, :locked, :ratio 
  def initialize(xp, yp, sw, sh, l)
    super()
    @swidth = sw
    @sheight = sh
    widthtoheight = sw - sh
    @ratio = sw.to_f / widthtoheight
    @xpos = xp
    @ypos = yp - sheight / 2
    @spos = xpos + swidth / 2 - sheight / 2
    @newspos = spos
    @spos_min = xpos
    @spos_max = xpos + swidth - sheight
    @loose = l
  end

  def update
    @over = over_event?
    @locked = (!mouse_pressed?)? false : (mouse_pressed? && over)? true : false  
    @newspos = constrain(mouse_x - sheight / 2, spos_min, spos_max) if locked    
    @spos = spos + (newspos - spos) / loose if (newspos - spos).abs > 1
  end

  def constrain(val, minv, maxv)
    min(max(val, minv), maxv)
  end

  def over_event?
    (mouse_x > xpos && mouse_x < xpos + swidth && mouse_y > ypos && mouse_y < ypos + sheight)
  end

  def display
    no_stroke
    fill(204)
    rect(xpos, ypos, swidth, sheight)
    if (over || locked)
      fill(0, 0, 0)
    else
      fill(102, 102, 102)
    end
    rect(spos, ypos, sheight, sheight)
  end

  def get_pos
    # Convert spos to be values between
    # 0 and the total width of the scrollbar
    spos * ratio
  end
end
