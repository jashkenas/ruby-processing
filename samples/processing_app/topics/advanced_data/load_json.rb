require "json"

attr_reader :data, :bubbles

def setup()
  size(640, 360)
  # read source_string from file
  source_string = open("data/data.json", "r").read
  # parse the source string and get the "bubbles" data
  @data = JSON(source_string)["bubbles"]
  @bubbles = []
  # create an array of bubbles from the data
  data.each do |point|
     bubbles << Bubble.new(
     point["position"]["x"],
     point["position"]["y"],
     point["diameter"],
     point["label"])
  end
end

def draw
  background 255
  bubbles.each do|bubble|
    bubble.display
    bubble.rollover(mouse_x, mouse_y)
  end
end

def mouse_pressed
  bubble = Bubble.new(mouse_x, mouse_y, rand(40 .. 80), "new label")
  source_object = bubble.to_hash.to_json
  puts JSON(source_object)
  @bubbles << bubble
end

class Bubble
  attr_reader :x, :y, :diameter, :name, :over	

  def initialize(x, y, diameter, name)
    @x, @y, @diameter, @name = x, y, diameter, name
    @over = false
  end

  def rollover px, py
    d = dist px, py, x, y
    @over = (d < diameter / 2.0)
  end

  def display
    stroke 0
    stroke_weight 2
    no_fill
    ellipse x, y, diameter, diameter
    if over
      fill 0
      text_align CENTER
      text(name, x, y + diameter / 2.0 +20)
    end
  end
  
  def to_hash
    {"position" => {"x" => x, "y" => y}, "diameter" => diameter, "label" => name}	  
  end
end
