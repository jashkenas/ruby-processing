require 'ruby-processing'

class MultipleZoogs < Processing::App

  def setup
    @w, @h = 60, 60
    @eye_size = 16
    @y = height/2
    smooth
    ellipseMode CENTER 
    rectMode CENTER
  end
  
  def draw
    background 255
    stroke 0 
    
    # Multiple versions of Zoog
    # If we want to show four Zoogs, let's draw it four times:
    
    4.times do |i|
      x = i * 80 + 80

      # Draw Zoog's body
      fill 175 
      rect x, @y, @w/6, @h*2 

      # Draw Zoog's head
      fill 255 
      ellipse x, @y-@h/2, @w, @h 

      # Draw Zoog's eyes
      fill 0 
      ellipse x-@w/3+1, @y-@h/2, @eye_size, @eye_size*2 
      ellipse x+@w/3-1, @y-@h/2, @eye_size, @eye_size*2 

      # Draw Zoog's legs
      line x-@w/12, @y+@h, x-@w/4, @y+@h+10 
      line x+@w/12, @y+@h, x+@w/4, @y+@h+10
    end
      
  end
  
end

MultipleZoogs.new :title => "Multiple Zoogs", :width => 400, :height => 200
