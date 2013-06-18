#
# Sequential
# by James Paterson.  
# 
# Displaying a sequence of images creates the illusion of motion. 
# Twelve images are loaded and each is displayed individually in a loop. 
#


NUM_FRAMES = 12  # The number of frames in the animation
attr_reader :frame, :images
    
def setup
  size(640, 360)
  frame_rate(24)
  @frame = 0
  @images = []
  images << loadImage("PT_anim0000.gif")
  images << loadImage("PT_anim0001.gif") 
  images << loadImage("PT_anim0002.gif")
  images << loadImage("PT_anim0003.gif") 
  images << loadImage("PT_anim0004.gif")
  images << loadImage("PT_anim0005.gif") 
  images << loadImage("PT_anim0006.gif")
  images << loadImage("PT_anim0007.gif") 
  images << loadImage("PT_anim0008.gif")
  images << loadImage("PT_anim0009.gif") 
  images << loadImage("PT_anim0010.gif")
  images << loadImage("PT_anim0011.gif")
end 
 
def draw 
  background(0)
  @frame = (frame + 1) % NUM_FRAMES  # Use % to cycle through frames
  offset = 0
  (-100 ... width).step(images[0].width) do |i|  
    image(images[(frame+offset) % NUM_FRAMES], i, -20)
    offset+=2
    image(images[(frame+offset) % NUM_FRAMES], i, height/2)
    offset+=2
  end
end
