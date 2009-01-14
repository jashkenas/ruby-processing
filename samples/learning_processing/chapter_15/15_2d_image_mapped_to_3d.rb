require 'ruby-processing'

class TwoDMappedTo3dSketch < Processing::App

  def setup
    @cellsize = 2
    @img = load_image 'sunflower.jpg' # Load the image
    @cols = width / @cellsize         # Calculate number of columns
    @rows = height / @cellsize        # Calculate number of rows
    render_mode P3D
  end

  def draw
    background 255
    @img.load_pixels
    # Begin loop for columns
    @cols.times do |i|
      # Begin loop for rows
      @rows.times do |j|
        x = i * @cellsize + @cellsize / 2  # x position
        y = j * @cellsize + @cellsize / 2  # y position
        loc = x + y * width            # Pixel array location
        c = @img.pixels[loc]           # Grab the color

        # Calculate a z position as a function of mouseX and pixel brightness
        z = (mouseX/width.to_f) * brightness(@img.pixels[loc]) - 100.0

        # Translate to the location, set fill and stroke, and draw the rect
        push_matrix
        translate x, y, z
        fill c
        no_stroke
        rect_mode CENTER
        rect 0, 0, @cellsize, @cellsize
        pop_matrix
      end
    end
  end

end

TwoDMappedTo3dSketch.new :title => "2d Mapped To 3d",  :width => 200,  :height => 200


