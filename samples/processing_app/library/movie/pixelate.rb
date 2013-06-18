#
# Pixelate  
# by Hernando Barragan.  
# 
# Load a QuickTime file and display the video signal 
# using rectangles as pixels by reading the values stored 
# in the current video frame pixels array. 
#

load_library :video
include_package 'processing.video'

BLOCK_SIZE = 10

attr_reader :mov, :movie_color, :num_pixels_wide, :num_pixels_high

def setup
  size(640, 360)
  no_stroke  
  @mov = Movie.new(self, "transit.mov")  
  @num_pixels_wide = width / BLOCK_SIZE
  @num_pixels_high = height / BLOCK_SIZE
  @movie_color = [] 
  puts num_pixels_wide
  mov.loop
end

# Display values from movie
def draw
  begin 
    movie_color.clear
    mov.read
    mov.load_pixels
    num_pixels_high.times do |j|
      num_pixels_wide.times do |i|
        movie_color << mov.get(i*BLOCK_SIZE, j*BLOCK_SIZE)
      end
    end
  end unless !mov.available? 

  num_pixels_high.times do |j|
    num_pixels_wide.times do |i|
      fill(movie_color[j*num_pixels_wide + i])
      rect(i*BLOCK_SIZE, j*BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
    end
  end  
end



