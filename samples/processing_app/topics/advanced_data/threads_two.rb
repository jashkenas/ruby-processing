##################
# From an original sketch on openprocessing by Chinchbug
# http://www.openprocessing.org/sketch/29577
##################
FRAMES = 116

attr_reader :ang, :curr, :frames, :done_loading

def setup
  size(305, 395)
  background(0)
  no_stroke
  text_align(CENTER, CENTER)
  @frames = []
  @done_loading = false
  @curr = 0
  thread do    # supply a block in ruby-processing rather than use reflection
    FRAMES.times do |i|
      frames << load_image("a#{nf(i, 3)} copy.jpg")
      @curr = i
      delay(75) #just slows down this thread - the main draw cycle is unaffected...
    end
    @curr = 0
    frame_rate(30)
    @done_loading = true
  end
  @ang = 0.0
end


def draw
  if (done_loading)
    background(0)    
    image(frames[curr], 0, 0)
    @curr += 1
    if (curr > 115)
      @curr = 0
    end
  else
    @ang += 0.1
    x = cos(ang) * 8
    y = sin(ang) * 8
    fill(0, 8)
    rect(50, 150, 100, 100)
    fill(32, 32, 255)
    ellipse(x + 100, y + 200, 8, 8)
    fill(0)
    rect(120, 150, 170, 100)
    fill(128)
    text("loading frames (#{curr} of 115)", 200, 200)
  end
end
