require "json"
load_library :bubble

attr_reader :bubbles, :bubble_data

def setup()
  size(640, 360)
  # read source_string from file
  load_data
end

def draw
  background 255
  bubbles.each do|bubble|
    bubble.display
    bubble.rollover(mouse_x, mouse_y)
  end
end

def load_data
  source_string = open("data/data.json", "r"){|file| file.read}
  # parse the source string
  @bubble_data = BubbleData.new

  # get the bubble_data from the top level hash
  data = bubble_data.extract_data source_string
  @bubbles = []
  # iterate the bubble_data array, and create an array of bubbles
  data.each do |point|
    bubbles << Bubble.new(
      point["position"]["x"],
      point["position"]["y"],
      point["diameter"],
      point["label"])
  end
end

def save_data
  # demonstrate how easy it is to create json object from a hash in ruby
  # json = bubble_data.to_hash.to_json # if you don't require pretty output
  json = JSON.pretty_generate(bubble_data.to_hash) # pretty output
  # overwite existing 'data.json' 
  open("data/data.json", 'w') {|f| f.write(json) }
end

def mouse_pressed
  # create a new bubble instance, where mouse was clicked
  @bubble_data.add_bubble(Bubble.new(mouse_x, mouse_y, rand(40 .. 80), "new label"))
  save_data
  # reload the json data from the freshly created file
  load_data
end

class BubbleData
  attr_reader :name, :data
  def initialize name = "bubbles"
    @name = name
    @data = []
  end

  def add_bubble bubble
    data << bubble  	  
  end

  def extract_data source_string
    @data = JSON.parse(source_string)[name]
  end
  
  def to_hash
    {name => data.map{|point| point.to_hash}}
  end

end


