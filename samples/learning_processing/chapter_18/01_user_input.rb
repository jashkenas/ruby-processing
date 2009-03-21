# Example 18-1: User input
require 'ruby-processing'

class UserInput < Processing::App

  def setup
    size 300, 200
    @typing = ""
    @saved  = ""
    textFont createFont "Arial", 16, true # set the font for text
  end

  def draw
    background 255
    indent = 25
    fill 0 # Set the fill for text

    # Display everything
    text "Click in this applet and type. \nHit return to save what you typed. ", indent, 40
    text @typing, indent, 90
    text @saved, indent, 130  
  end

  def keyPressed
    # If the return key is pressed, save the String and clear it
    if key == "\n"
      @saved  = @typing
      @typing = "" # A String can be cleared by setting it equal to ""
    else
      # Otherwise, concatenate the String
      # Each character typed by the user is added to the 
      # end of the String variable.
      @typing = @typing + key 
    end
  end

end

UserInput.new :title => "01 User Input"