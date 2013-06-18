#
# Loading XML Data
# by Daniel Shiffman.  
# 
# This example demonstrates how to use loadXML
# to retrieve data from an XML file and make objects 
# from that data.
#
# Here is what the XML looks like:
#
# <?xml version="1.0"?>
# <bubbles>
#  <bubble>
#    <position x="160" y="103"/>
#    <diameter>43.19838</diameter>
#    <label>Happy</label>
#  </bubble>
#  <bubble>
#    <position x="372" y="137"/>
#    <diameter>52.42526</diameter>
#    <label>Sad</label>
#  </bubble>
# </bubbles>
#
load_library "bubble"
 
attr_reader :bubbles, :xml

def setup
  size(640, 360)
  load_data
end

def draw
  background(255)
  # Display all bubbles
  bubbles.each do |b|
    b.display
    b.rollover(mouseX, mouseY)
  end

  text_align(LEFT)
  fill(0)
  text("Click to add bubbles.", 10, height - 10)
end

def load_data
  # Load XML file
  @xml = loadXML("data.xml")
  # Get all the child nodes named "bubble"
  children = xml.get_children("bubble")

  # The size of the array of Bubble objects is determined by the total XML elements named "bubble"
  @bubbles = []

  children.each do |element|    
    # The position element has two attributes: x and y
    position_element = element.get_child("position")
    # Note how with attributes we can get an integer or directly
    x, y = position_element.get_int("x"), position_element.get_int("y")
    
    # The diameter is the content of the child named "diamater"
    diameter_element = element.get_child("diameter")
    # Note how with the content of an XML node, we retrieve as a String and then convert
    diameter = (diameter_element.get_content).to_f

    # The label is the content of the child named "label"
    label_element = element.get_child("label")
    label = label_element.get_content

    # Make a Bubble object out of the data read
    bubbles << Bubble.new(x, y, diameter, label)
  end 

end

# Still need to work on adding and deleting

def mouse_pressed
  
  # Create a new XML bubble element
  bubble = xml.add_child("bubble")
  
  # Set the poisition element
  position = bubble.add_child("position")
  # Here we can set attributes as integers directly
  position.set_int("x",mouseX)
  position.set_int("y",mouseY)
  
  # Set the diameter element
  diameter = bubble.add_child("diameter")
  # Here for a node's content, we have to convert to a String
  diameter.set_content(rand(40.0 .. 80).to_s)
  
  # Set a label
  label = bubble.add_child("label")
  label.set_content("New label")
  
  
  # Here we are removing the oldest bubble if there are more than 10
  children = xml.get_children("bubble")
    # If the XML file has more than 10 bubble elements
  if (children.length > 10)
    # Delete the first one
    xml.remove_child(children[0])
  end
  
  # Save a new XML file
  saveXML(xml,"data/data.xml")
  
  # reload the new data 
  load_data
end

