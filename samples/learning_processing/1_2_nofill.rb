require 'ruby-processing'

class NofillApp < Processing::App

  def setup
    smooth
    background 255
    # In Ruby, methods and variables are under_scored instead of camelCased
    no_fill
    stroke 0
    # You might notice that there are no parenthesis or semicolons.
    # That's because they're optional.
    ellipse 60, 60, 100, 100
    # This line works too:
    ellipse(60, 60, 100, 100);
  end
  
  def draw
  
  end
  
end

# The names of classes are still camel cased.
NofillApp.new :title => "Nofill", :width => 200, :height => 200