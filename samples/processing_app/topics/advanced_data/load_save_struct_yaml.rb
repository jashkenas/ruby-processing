######################################
# Yet another examples of reading and
# writing to some form of markup,
# appropriately yaml using ruby structs 
# by Martin Prout after Dan Shiffman
####################################
load_library :bubble

attr_reader :bubble_data


def setup()
  size(640, 360)
  @bubble_data = BubbleData.new :bubbles
  bubble_data.load_data "data/struct_data.yml"
end

def draw
  background 255
  bubble_data.display mouse_x, mouse_y
end


def mouse_pressed
  # create a new bubble instance, where mouse was clicked
  bubble_data.create_new_bubble(mouse_x, mouse_y)
end


class BubbleData
  include Enumerable
  
  MAX_BUBBLE = 10

  attr_reader :path, :bubble_array
  def initialize key
    @bubble_array = []
    @key = key
  end
  
  def each &block
    bubble_array.each &block
  end  
  
  def create_new_bubble x, y
    self.add Bubble.new(x, y, rand(40 .. 80), "new label")    
    save_data 
    load_data path
  end

  def add bubble
    bubble_array << bubble
    bubble_array.shift if bubble_array.size > MAX_BUBBLE
  end 
 
   def load_data path
     @path = path
     yaml = Psych.load_file(path)
     # we are storing the data as an array of RubyStruct, in a hash with
     # a symbol as the key (the latter only to show we can, it makes no sense)
     data = yaml[@key]      
     bubble_array.clear
     # iterate the bubble_data array, and populate the array of bubbles
     data.each do |pt|
       self.add Bubble.new(pt.x, pt.y, pt.diameter, pt.label)
     end
  end

  def display x, y
    self.each do |bubble|
      bubble.display
      bubble.rollover(x, y)
    end
  end  

  private   
  
  def save_data
    hash = { @key =>  self.map{ |point| point.to_struct } }
    yaml = hash.to_yaml
    # overwite existing 'struct_data.yaml' 
    open(path, 'w:UTF-8') {|f| f.write(yaml) }
  end

end
