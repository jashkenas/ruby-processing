# Taken from processing discussion board, a little sketch by Amnon Owed
# Illustrates use of offscreen image, texture sampling, mouse_pressed?,
# load_pixels, displayWidth and displayHeight (do not snake case the last two)

SCALE = 5  
COLOR_RANGE = 16581375 # 255 * 255 * 255
# full_screen # fill screen so no title bar

attr_reader :grid
 
def setup
  size(displayWidth, displayHeight, P2D)
  @grid = create_image(width/SCALE, height/SCALE, RGB)
  g.texture_sampling(2)       # 2 = POINT mode sampling
end
 
def draw
  unless mouse_pressed?
    grid.load_pixels
    grid.pixels.length.times do |i|
      grid.pixels[i] = rand(COLOR_RANGE)
    end
    grid.update_pixels
  end
  image(grid, 0, 0, width, height)
  frame.set_title("#{frame_rate.to_i}+ fps")
end
