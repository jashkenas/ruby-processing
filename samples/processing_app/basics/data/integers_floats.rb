# Integers and floats are two different kinds of numerical data. 
# An integer (more commonly called an int) is a number without 
# a decimal point. A float is a floating-point number, which means 
# it is a number that has a decimal place. Floats are used when
# more precision is needed. 


def setup
  size 200, 200  
  stroke 255
  frame_rate 30
  
  @a = 0		# Create an instance variable "a" of class Integer
  @b = 0.0	# Create an instance variable "b" of class Float (because of "0.0")
end

def draw
  background 51
  
  @a += 1
  @b += 0.2
  
  line @a, 0,        @a, height/2
  line @b, height/2, @b, height
  
  @a = 0 if @a > width
  @b = 0 if @b > width
end
