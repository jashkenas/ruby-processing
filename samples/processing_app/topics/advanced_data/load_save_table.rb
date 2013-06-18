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
 
load_library "bubble"

attr_reader :bubbles, :table

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
  table = load_table("data.csv","header")

  # The size of the array of Bubble objects is determined by the total number of rows in the CSV
  @bubbles = [] 

  table.rows.each do |row|
    # You can access the fields via their column name (or index)
    x = row.getFloat("x")
    y = row.getFloat("y")
    d = row.getFloat("diameter")
    n = row.getString("name")
    # Make a Bubble object out of the data read
    bubbles << Bubble.new(x, y, d, n)
  end  

end

def mousePressed
  # Create a new row
  row = table.addRow
  # Set the values of that row
  row.setFloat("x", mouseX)
  row.setFloat("y", mouseY)
  row.setFloat("diameter", random(40, 80))
  row.setString("name", "Blah")
  
  # If the table has more than 10 rows
  if (table.getRowCount > 10)
    # Delete the oldest row
    table.removeRow(0) 
  end

  # Writing the CSV back to the same file
  save_table(table, "data/data.csv")
  # And reloading it
  load_data
end

