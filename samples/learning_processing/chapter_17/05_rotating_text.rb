def setup
  size 200, 200
  @message = "this text is spinning"
  @theta   = 0.0
  @f       = create_font "Arial", 20, true
end

def draw
  background 255
  fill 0
  text_font @f                     # Set the font
  translate width / 2, height / 2  # Translate to the center
  rotate @theta                    # Rotate by theta
  text_align CENTER

  # The text is center aligned and displayed at  0,0) after translating and rotating. 
  # See Chapter 14 or a review of translation and rotation.
  text @message, 0, 0

  # Increase rotation
  @theta += 0.05;  
end