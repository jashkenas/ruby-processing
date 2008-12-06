require 'ruby-processing'

class SimpleBuffer < Processing::App
  def setup
    
    # With Processing, buffers allow you to draw off-screen to an image,
    # and then use that image in your sketch. This can speed up rendering
    # times quite a bit, as it's not only faster to draw off-screen, but
    # it also allows you to redraw only portions of the screen.
    
    # Ruby-Processing provides a convenience method, "buffer", which
    # sets up a buffer for you with the same width and height and 
    # renderer as the current sketch, and yields it to you. It also
    # takes care of calling begin_draw and end_draw at the start and 
    # end of the block. Use it like so:
    
    @buffer = buffer do |b|
      b.no_stroke
      b.fill 255, 0, 0
      b.rect 100, 200, 100, 100
    end
    
    # Those lines are equivalent to the following lines:
    
    @buffer_2 = create_graphics(500, 500, P3D)
    @buffer_2.begin_draw
    @buffer_2.no_stroke
    @buffer_2.fill(255, 0, 0)
    @buffer_2.rect(100, 200, 100, 100)
    @buffer_2.end_draw
    
    # If you'd like to set the size or renderer for the buffer block,
    # just pass it in like normal:
    
    @buffer_3 = buffer(150, 150, P3D) do |b|
      # b.whatever goes here.
    end
    
    # And now we go ahead and grab the rendered image from the first buffer.
    @img = @buffer.get(0, 0, @buffer.width, @buffer.height)
  end
  
  def draw
    background 0
    image @img, frame_count, 0
  end
end

SimpleBuffer.new :title => "Simple Buffer", :width => 500, :height => 500