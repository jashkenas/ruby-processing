# Example 17-2: Text align
require 'ruby-processing'

class TextAlign < Processing::App

  def setup
    size 400, 200
    @f = createFont "Arial", 16, true
  end

  def draw
    background 255
    stroke 175
    line width / 2, 0, width / 2, height
    textFont @f
    fill 0

    # textAlign() sets the alignment for displaying text. It takes one argument: CENTER, LEFT, or RIGHT.
    textAlign CENTER
    text "This text is centered.", width / 2, 60
    textAlign LEFT
    text "This text is left aligned.", width/2, 100
    textAlign RIGHT
    text "This text is right aligned.", width / 2, 140
  end

end

TextAlign.new :title => "02 Text Align"