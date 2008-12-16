require 'ruby-processing'

class MultipleTranslationsSketch < Processing::App

  def setup
    smooth
  end

  def draw
    background 255
    stroke 0
    fill 175

    # Grab mouse coordinates,  constrained to window
    mx = constrain(mouse_x, 0, width)
    my = constrain(mouse_y, 0, height)

    # Translate to the mouse location
    translate mx, my
    ellipse 0, 0, 8, 8

    # Translate 100 pixels to the right
    translate 100, 0
    ellipse 0, 0, 8, 8

    # Translate 100 pixels down
    translate 0, 100
    ellipse 0, 0, 8, 8

    # Translate 100 pixels left
    translate -100, 0
    ellipse 0, 0, 8, 8
  end

end

MultipleTranslationsSketch.new :title => "Multiple Translations", :width => 200, :height => 200
