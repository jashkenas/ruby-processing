require 'ruby-processing'

class ImageBrightnessSketch < Processing::App

  def setup
    @image = load_image 'sunflower.jpg'
    # Let's grab the red, green and blue component of each pixel of the image to start with.
    @image_pixels = @image.pixels.map {|p| [red(p), green(p), blue(p)]}
  end

  def draw
    # We calculate a multiplier ranging from 0.0 to 8.0 based on mouseX position. 
    # That multiplier changes the RGB value of each pixel.      
    adjustment = (mouse_x.to_f / width) * 8.0 
    load_pixels # load the pixels array
    
    # And here's a modified Ruby way to do the Java equivalent
    pixels.size.times do |i|
      pixels[i] = color(*@image_pixels[i].map {|rgb| rgb * adjustment })
    end
    
    update_pixels
  end

end

ImageBrightnessSketch.new :title => "Image Brightness", :width => 200, :height => 200


