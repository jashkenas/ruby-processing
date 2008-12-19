require 'ruby-processing'

class ImageSpriteSketch < Processing::App

  def setup
    @head = load_image("face.jpg")  # variable for the image file
    @x, @y = 0, width/2             # variables for image location
    @rot = 0.0                      # variable for image rotation
  end

  def draw
    background 255

    translate @x, @y
    rotate @rot

    # Images can be animated just like regular shapes using variables, translate, rotate, and so on.
    image @head, 0, 0
    # Adjust variables for animation
    @x += 1.0
    @rot += 0.02
    @x = -@head.width if @x > width + @head.width
  end

end

ImageSpriteSketch.new :title => "Image Sprite", :width => 200, :height => 200


