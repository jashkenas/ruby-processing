# Conditions are like questions.
# They allow a program to decide to take one action if
# the answer to a question is true or to do another action
# if the answer to the question is false.
# The questions asked within a program are always logical
# or relational statements. For example, if the variable 'i' is
# "even" then draw short line, else draw a long one.


def setup
  size 640, 360
  background 0
  stroke_weight 8
  (5 ... width/2).step(5) do |i|
    i.even? ? draw_short(i) : draw_long(i)
  end
end

def draw_short(i)
  stroke 255
  line i * 2, 80, i * 2, height/2
end

def draw_long(i)
  stroke 153
  line i * 2, 20, i * 2, 180
end
