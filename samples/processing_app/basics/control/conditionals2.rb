

# We extend the language of conditionals by adding the 
# keyword "elsif". This allows conditionals to ask 
# two or more sequential questions, each with a different
# action. 


def setup
  size 640, 360
  background 0  	
  (2 ... width - 2 ).step(2) do |i|
    
    # If 'i' divides by 20 with no remainder 
    # draw the first line .. 
    # else if 'i' divides by 10 with no remainder 
    # draw second line, else draw third line
    
    if (i % 20) == 0
      
      stroke 255
      line i, 80, i, height/2
      
    elsif (i % 10) == 0
      
      stroke 153
      line i, 20, i, 180
      
    else
      
      stroke 102
      line i, height/2, i, height-20
      
    end
    
  end
  
end

