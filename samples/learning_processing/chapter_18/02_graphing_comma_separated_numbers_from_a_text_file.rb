#
# Example 18-2: Graphing comma separated numbers from a text file
#
def setup
  size 200, 200
  # The text from the file is loaded into an array. 
  stuff = loadStrings("data-1.txt")

  # This array has one element because the file only has one line. 
  # Convert String into an array of integers using ',' as a delimiter
  @data = int(split(stuff[0], ","))
end

def draw
  background 255
  stroke 0
  @data.each_with_index do |data, i|
    # The array of ints is used to set the color and height of each rectangle.
    fill data
    rect i * 20, 0, 20, data
  end
end
