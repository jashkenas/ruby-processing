######################################
# Yet another examples of reading and
# writing to some form of markup,
# appropriatetly yaml.
# by Martin Prout after Dan Shiffman
# ###################################
load_library :bubble

attr_reader :bubbles, :bubble_data

def setup()
  size(640, 360)
  # load data from file
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
  yaml = Psych.load_file("data/data.yaml")
  # parse the source string
  @bubble_data = BubbleData.new "bubbles"

  # get the bubble_data from the top level hash
  data = bubble_data.extract_data yaml
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
  # demonstrate how easy it is to create yaml object from a hash in ruby
  yaml = bubble_data.to_hash.to_yaml
  # overwite existing 'data.yaml' 
  open("data/data.yaml", 'w') {|f| f.write(yaml) }
end

def mouse_pressed
  # create a new bubble instance, where mouse was clicked
  @bubble_data.add_bubble(Bubble.new(mouse_x, mouse_y, rand(40 .. 80), "new label"))
  save_data
  # reload the yaml data from the freshly created file
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

  def extract_data yaml
    @data = yaml[name]
  end

  def to_hash
    {name => data.map{|point| point.to_hash}}
  end

end


