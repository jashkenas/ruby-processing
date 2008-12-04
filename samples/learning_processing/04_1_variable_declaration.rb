require 'ruby-processing'

# Ruby has dynamic typing, so you don't have to say
# what kind of thing a variable is before using it.
class VariableDeclaration < Processing::App

  def setup
    count = 0         # count gets assigned 0, an integer (Fixnum)
    letter = 'a'      # letter gets the letter 'a', a String
    d = 132.32        # d gets the decimal 132.32, a Float (floating-point number)
    happy = false     # happy gets false, a Boolean (true or false)
    x = 4.0           # x gets 4.0, another Float
    y = nil           # y gets nil, which stands for nothing
    y = x + 5.2       # assign the value of x plus 5.2 to y
    z = x * y + 15.0  # z gets the value of x times y plus 15.0 (or 51.8)
  end
  
  def draw
  
  end
  
end

VariableDeclaration.new :title => "Variable Declaration and Initialization Examples", :width => 200, :height => 200