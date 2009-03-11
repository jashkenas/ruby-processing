require 'ruby-processing'

# Original by luis2048

# A picture is shown and it looks like a magnifying glass 
# is drawn over the picture. One of the most famous demos 
# that has a lens effect is 2nd reality by future crew.
# The trick is to precalculate the entire effect. Just make 
# an array that for each pixel in the destination picture 
# tells which pixel to take from the source picture. This 
# array is called the transformation array. The tricky part 
# is to calculate the transformation array to make the 
# destination look like a lens is beeing held over the source 
# picture. Based on lens formula by on Abe Racadabra.

class Lens < Processing::App

  def setup
    render_mode P2D
    @lens_d            = 160
    @lens_list         = []
    @xx, @yy, @dx, @dy = 0, 0, 3, 3
    
    # Create buffered image for lens effect.
    @lens_effect = create_graphics(width, height, P2D)
    
    # Load background image.
    @lens_effect.begin_draw
    @lens_effect.image(load_image('red_smoke.jpg'), 0, 0, width, height)
    @lens_effect.end_draw
    image(@lens_effect, 0, 0, width, height)
    
    # Create buffered image for warping.
    @lens_image  = create_graphics(@lens_d, @lens_d, P2D)
    @lens_image2 = create_graphics(@lens_d, @lens_d, P2D)
    
    compute_lens_transformation
  end
  
  def compute_lens_transformation
    mag_factor = 40
    m, a, b    = 0, 0, 0
    r          = @lens_d / 2
    s          = sqrt(r*r - mag_factor*mag_factor)
    
    for y in (-r...r)
      for x in (-r..r)
        if (x*x + y*y >= s*s)
          a, b = x, y
        else
          z = sqrt(r*r - x*x - y*y)
          a = (x * mag_factor / z + 0.5).to_i
          b = (y * mag_factor / z + 0.5).to_i
        end
        @lens_list[(y+r) * @lens_d + (x+r)] = (b+r) * @lens_d + (a+r)
      end
    end
  end
  
  def bounce_lens
    @dx = -@dx if (@xx+@dx+@lens_d > @lens_effect.width)  || (@xx+@dx < 0)
    @dy = -@dy if (@yy+@dy+@lens_d > @lens_effect.height) || (@yy+@dy < 0)
  end
  
  def move_lens
    @xx += @dx
    @yy += @dy
  end
  
  def draw
    bounce_lens
    move_lens
        
    # Save the background of image at the coordinate where the
    # lens effect will be applied.
    @lens_image2.copy(@lens_effect, @xx, @yy, @lens_d, @lens_d, 0, 0, @lens_d, @lens_d)
    
    # Output into a buffered image for reuse.
    @lens_image.load_pixels
    
    # For each pixel in the destination, apply the color from the 
    # appropriate pixel in the saved background. The @lens_list array
    # tells us the appropriate offset.
    # This inner loop has been optimized a bit.
    px, px2  = @lens_image.pixels, @lens_image2.pixels
    list     = @lens_list
    px.length.times {|i| px[i] = px2[list[i]] }
    @lens_image.update_pixels
    
    # Overlay the lens
    image(@lens_image, @xx, @yy, @lens_d, @lens_d)
  end
  
end

Lens.new :title => "Lens", :width => 640, :height => 360
