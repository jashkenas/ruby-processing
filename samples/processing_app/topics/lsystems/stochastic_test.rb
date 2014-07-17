#######################################################
# stochastic_test.rb
#
# Lindenmayer System in ruby-processing by Martin Prout
# Exploring terminals with minimum logic 
########################################################


load_library :stochastic_grammar, :fastmath

Turtle = Struct.new(:x, :y, :angle)

class StochasticPlant
  include Processing::Proxy

  attr_reader :grammar, :axiom, :draw_length, :turtle, :production

  DELTA = 23

  def initialize xpos, ypos   
    @draw_length = 350
    # use Struct as turtle
    @turtle = Turtle.new(xpos, ypos, 90)        # this way is up?
    setup_grammar
  end

  def setup_grammar
    @axiom = "F"
    @grammar = StochasticGrammar.new(axiom)           
    grammar.add_rule("F", "F[+F]F[-F]F", 0.1)     
    grammar.add_rule("F", "F[+F]F", 0.45)           
    grammar.add_rule("F", "F[-F]F", 0.45)
    @production = axiom
  end

  def render
    stack = []                     # ruby array as the turtle stack    
    production.each_char do |element|
      case element
      when 'F'                     # NB NOT using affine transforms
        @turtle = draw_line(turtle, draw_length)
      when '+'
        turtle.angle += DELTA
      when '-'
        turtle.angle -= DELTA   
      when '['
        stack << turtle.dup    # push a copy of the current turtle to stack 
      when ']'
        @turtle = stack.pop        # assign current turtle to an instance popped from the stack
      else
        puts "Character '#{element}' is not in grammar"
      end
    end
  end

  def create_grammar gen
    @draw_length *= 0.5**gen
    @production = grammar.generate gen
  end

  private
  ######################################################
  # draws a line using current turtle and length parameters
  # returns a new turtle corresponding to the next position
  ######################################################

  def draw_line(turtle, length)
    new_xpos = turtle.x + length * DegLut.cos(turtle.angle)
    new_ypos = turtle.y - length * DegLut.sin(turtle.angle)
    line(turtle.x, turtle.y, new_xpos, new_ypos) 
    Turtle.new(new_xpos, new_ypos, turtle.angle)
  end
end


attr_reader :stochastic, :stochastic1, :stochastic2

def setup
  size 1000, 800
  @stochastic = StochasticPlant.new 200, 700
  @stochastic1 = StochasticPlant.new 500, 700
  @stochastic2 = StochasticPlant.new 700, 700
  stochastic.create_grammar 5
  stochastic1.create_grammar 4 # simpler plant
  stochastic2.create_grammar 5
  no_loop
end

def draw
  background 0
  stroke(0, 255, 0)
  stroke_width(3)
  stochastic.render
  stochastic1.render
  stochastic2.render
end
