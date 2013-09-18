#
# Loading Tabular Data
# by Daniel Shiffman.  
# 
# This example demonstrates how to use loadTable
# to retrieve data from a CSV file and make objects 
# from that data.
#
# Here is what the CSV looks like:
#
#   x,y,diameter,name
#   160,103,43.19838,Happy
#   372,137,52.42526,Sad
#   273,235,61.14072,Joyous
#   121,179,44.758068,Melancholy
#
require 'csv'

load_library "bubble"

attr_reader :bubbles, :data

def setup
  size(640, 360)
  load_data
end

def draw
  background(255)
  # Display all bubbles
  bubbles.each do |b|
    b.display
    b.rollover(mouse_x, mouse_y)
  end
  
  text_align(LEFT)
  fill(0)
  text("Click to add bubbles.", 10, height - 10)
end

def load_data
  # Load CSV file into a Table object
  # "header" option indicates the file has a header row
  @data = CSV.read("data/data.csv", :headers => true).map{|row| row.to_hash}
  
  # The size of the array of Bubble objects is determined by the total number of rows in the CSV
  @bubbles = [] 
  
  data.each do |row|
    # You can access the fields via their column name (or index)
    x = row["x"].to_f
    y = row["y"].to_f
    d = row["diameter"].to_f
    n = row["name"] 
    # Make a Bubble object out of the data read
    bubbles << Bubble.new(x, y, d, n)
  end  
  
end

def mousePressed
  # Create a new row
  row = {"x" => mouse_x.to_s, "y" => mouse_y.to_s, "diameter" => random(40, 80).to_s, "name" => "Blah"}
  # Set the values of that row
  data << row
  
  # If the table has more than 10 rows
  if (data.size > 10)
    # Delete the oldest row
    
    data.delete_at(0)
  end    
  column_names = data.first.keys
  s = CSV.generate do |csv|
    csv << column_names
    data.each do |row|
      csv << row.values
    end
  end
  # Writing the CSV back to the same file
  File.write("data/data.csv", s)  
  # And reloading it
  load_data
end

