def setup
  size 400, 200
  @font = create_font "Arial", 16, true
end

def draw
  background 255
  stroke 175
  line width/2, 0, width/2, height
  text_font @font
  fill 0

  # text_align sets the alignment for displaying text. 
  # It takes one argument: CENTER, LEFT, or RIGHT.
  text_align CENTER
  text "This text is centered.", width / 2, 60
  text_align LEFT
  text "This text is left aligned.", width/2, 100
  text_align RIGHT
  text "This text is right aligned.", width / 2, 140
end
