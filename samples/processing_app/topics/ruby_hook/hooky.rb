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
  Hooky.new(x: i * 90, y: i* 90, title: "Hooky #{i}", background: col)
end
