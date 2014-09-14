# This example demonstrates how easily 'sketch data' can be retrieved from a json file
# in ruby-processing. Note this sketch re-uses the Bubble class from the bubble library. 
# The BubbleData class, can load, store and create instances of Bubble (and request them
# to display and/or show their label, when 'mouse over').
# @author Martin Prout, after Daniel Shiffmans version for processing
# 
require 'json'

load_library :bubble

attr_reader :bubble_data

def setup
  size(640, 360)
  # initialize bubble_data with 'key' and read data from 'file path'
  @bubble_data = BubbleData.new 'bubbles'
  bubble_data.load_data 'data/data.json'
end

def draw
  background 255
  # draw the bubbles and display a bubbles label whilst mouse over
  bubble_data.display mouse_x, mouse_y
end

def mouse_pressed
  # create a new instance of bubble, where mouse was clicked
  bubble_data.create_new_bubble(mouse_x, mouse_y)
end

class BubbleData 
  include Enumerable
  
  MAX_BUBBLE = 10
  
  attr_reader :key, :path, :bubbles
  
  # @param key String for top level hash
  
  def initialize key
    @key = key
    @bubbles = []
  end
  
  def each &block
    bubbles.each &block
  end  
  
  def create_new_bubble x, y
    self.add Bubble.new(x, y, rand(40..80), 'new label')    
    save_data 
    load_data path
  end
  
  def display x, y
    self.each do |bubble|
      bubble.display
      bubble.rollover(x, y)
    end
  end
  
  # @param path to json file
  
  def load_data path
    @path = path
    source_string = open(path, 'r'){ |file| file.read }
    data = JSON.parse(source_string)[key]
    bubbles.clear
    # iterate the bubble_data array, and create an array of bubbles
    data.each do |point|
      self.add Bubble.new(
        point['position']['x'],
        point['position']['y'],
        point['diameter'],
        point['label'])
    end
  end
  
  def add bubble
    bubbles << bubble
    bubbles.shift if bubbles.size > MAX_BUBBLE
  end 
  
  private   
  
  def save_data
    hash = { key => self.map{ |point| point.to_hash } }
    json = JSON.pretty_generate(hash)      # generate pretty output
    open(path, 'w') { |f| f.write(json) }
  end
  
end

