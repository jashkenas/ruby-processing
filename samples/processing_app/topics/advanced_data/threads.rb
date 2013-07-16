# 
# Thread function example
# by Martin Prout (after a Dan Schiffman vanilla processing version).  
# 
# This example demonstrates how to use Thread.new to spawn
# a process that happens outside of the main animation thread.
#
# When Thread.new is called, the draw() loop will continue while
# the code inside the block passed to the thread will operate
# in the background.
#
# For more about threads, see: http://wiki.processing.org/w/Threading
#

# This sketch will load data from all of these URLs in a separate thread

URLS = [
"http://processing.org", 
"http://www.processing.org/exhibition/", 
"http://www.processing.org/reference/", 
"http://www.processing.org/reference/libraries", 
"http://www.processing.org/reference/tools",   
"http://www.processing.org/reference/environment",   
"http://www.processing.org/learning/", 
"http://www.processing.org/learning/basics/", 
"http://www.processing.org/learning/topics/", 
"http://www.processing.org/learning/gettingstarted/",
"http://www.processing.org/download/", 
"http://www.processing.org/shop/", 
"http://www.processing.org/about/"
]


attr_reader :finished, :percent

def setup
  size(640, 360)
  # Spawn the thread!
  # This will keep track of whether the thread is finished
  load_data
end

def draw
  background(0)
  
  # If we're not finished draw a "loading bar"
  # This is so that we can see the progress of the thread
  # This would not be necessary in a sketch where you wanted to load data in the background
  # and hide this from the user, allowing the draw() loop to simply continue
  if (!finished)
    stroke(255)
    no_fill()
    rect(width/2-150, height/2, 300, 10)
    fill(255)
    # The size of the rectangle is mapped to the percentage completed
    w = map(percent, 0, 1, 0, 300)
    rect(width/2-150, height/2, w, 10)
    text_size(16)
    text_align(CENTER)
    fill(255)
    text("Loading", width/2, height/2+30)
  else
    # The thread is complete!
    text_align(CENTER)
    text_size(24)
    fill(255)
    text("Finished loading. Click the mouse to load again.", width/2, height/2)
  end
end

def load_data
  Thread.new { 
    # The thread is not completed
    @finished = false
    @percent = 0
    # Reset the data to empty
    @all_data = ""
    URLS.each_with_index do |url, i|
      lines = load_strings(url)
      all_txt = lines.join(' ')
      words = all_txt.scan(/\w+/)
      words.each do |word|
        word.strip! 
        word.downcase!
      end
      words.sort!
      @all_data << words.join(' ')
      @percent = i.to_f / URLS.length
    end
    @finished = true
  }
end

def mouse_pressed   # guard against calling load_data when running
  load_data unless !finished 
end
