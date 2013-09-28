######################################
# Yet another examples of reading and
# writing to some form of markup,
# appropriately yaml.
# by Martin Prout after Dan Shiffman
# ###################################
load_library :bubble

attr_reader :bubble_data

def setup()
  size(640, 360)
  # load data from file
  @bubble_data = BubbleData.new "bubbles"
  bubble_data.load_data "data/data.yml"
end

def draw
  background 255
  bubble_data.display mouse_x, mouse_y
end

def mouse_pressed
  # create a new bubble instance, where mouse was clicked
  @bubble_data.create_new_bubble(mouse_x, mouse_y)
end

class BubbleData 
  include Enumerable
  
  MAX_BUBBLE = 10
  
  attr_reader :key, :path, :bubbles
  def initialize key
    @key = key
    @bubbles = []
  end
  
  def each &block
    bubbles.each &block
  end  
  
  def create_new_bubble x, y
    self.add Bubble.new(x, y, rand(40 .. 80), "new label")    
    save_data 
    load_data path
  end
  
  def display x, y
    self.each do |bubble|
      bubble.display
      bubble.rollover(x, y)
    end
  end
  
  # @param path to yaml file
  
  def load_data path
    @path = path
    yaml = Psych.load_file("data/data.yml")
    data = yaml[key]
    bubbles.clear
    # iterate the bubble_data array, and create an array of bubbles
    data.each do |point|
      self.add Bubble.new(
        point["position"]["x"],
        point["position"]["y"],
        point["diameter"],
        point["label"])
    end
  end
  
  
  def add bubble
    bubbles << bubble
    bubbles.shift if bubbles.size > MAX_BUBBLE
  end 
  
  private   
  
  def save_data
    hash = { key => self.map{ |point| point.to_hash } }
    yaml = hash.to_yaml
    # overwite existing 'data.yaml' 
    open("data/data.yml", 'w:UTF-8') {|f| f.write(yaml) }
  end
  
end

