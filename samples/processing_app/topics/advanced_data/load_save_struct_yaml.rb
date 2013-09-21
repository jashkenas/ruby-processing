######################################
# Yet another examples of reading and
# writing to some form of markup,
# appropriatetly yaml using ruby structs 
# by Martin Prout after Dan Shiffman
####################################
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
  yaml = Psych.load_file("data/struct_data.yml")
  # we are storing the data as an array of RubyStruct, in a hash with
  # a symbol as the key (the latter only to show we can, it makes no sense)
  data = yaml[:bubbles] 
  @bubbles = []
  # iterate the bubble_data array, and populate the array of bubbles
  data.each do |pt|
    bubbles << Bubble.new(pt.x, pt.y, pt.diameter, pt.label)
  end
end

def save_data
  # demonstrate how easy it is to create yaml object from a hash in ruby
  yaml = bubble_data.to_hash.to_yaml
  # overwite existing 'data.yaml' 
  open("data/struct_data.yml", 'w') {|f| f.write(yaml) }
end

def mouse_pressed
  # create a new bubble instance, where mouse was clicked
  @bubble_data = BubbleData.new bubbles
  @bubble_data.add_bubble(Bubble.new(mouse_x, mouse_y, rand(40 .. 80), "new label"))
  save_data
  # reload the yaml data from the freshly created file
  load_data
end


class BubbleData
  attr_reader :data
  def initialize data
    @data = data
  end

  def add_bubble bubble
    data << bubble
    if (data.size > 10)
    # Delete the oldest bubble
      data.shift
    end
  end

  # Using symbol as hash key for a change.  Thus demonstrating we can store 
  # more complex data strucures quite readily.
  def to_hash
    {bubbles: data.map{|point| point.to_struct}}
  end

end

