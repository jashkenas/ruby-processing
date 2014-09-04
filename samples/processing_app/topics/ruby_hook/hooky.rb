# Hooky class demonstrates how to use the post_initialize hook,
# available since ruby-processing-2.6.2, to additional attribute
# in this case :background as an array of int (splat to color)
# Not sure how clever it is to have multiple sketch instances.

class Hooky < Processing::App
  attr_reader :back

  def setup
    size 200, 200
    background(*back)
  end

  def post_initialize(args)
    @back = (args[:background])
  end
end

red = [200, 0, 0]
green = [0, 200, 0]
blue = [0, 0, 200]
colors = [red, green, blue]

colors.each_with_index do |col, i|
  Hooky.new(x: i * 90, y: i * 90, title: "Hooky #{i}", background: col)
end
