#######################################################
# Lindenmayer System in ruby-processing by Martin Prout
# snake_kolam.rb using l-systems
#######################################################

load_library 'grammar'

class SnakeKolam
  include Processing::Proxy
  import 'grammar'
  attr_accessor :axiom, :start_length, :xpos, :ypos, :grammar, :production, :draw_length, :gen
  XPOS = 0
  YPOS = 1
  ANGLE = 2
  DELTA = (PI/180) * 90.0 # convert degrees to radians
  
  def initialize xpos, ypos
    setup_grammar
    @start_length = 120.0
    @theta = (PI/180) * 90.0 # convert degrees to radians
    @draw_length = start_length
    @xpos = xpos 
    @ypos = ypos 
  end
  
  def setup_grammar
    @axiom = "FX+F+FX+F"
    @grammar = Grammar.new(
      axiom,
      {"X" => "X-F-F+FX+F+FX-F-F+FX"}
      )
  end
    
  def render                     # NB not using affine transforms here
    turtle = [xpos, ypos, 0.0]
    production.each do |element|
      case element
      when 'F'                     
        turtle = draw_line(turtle, draw_length)
      when '+'
        turtle[ANGLE] += DELTA   # rotate by + theta if going the affine transform route
      when '-'
        turtle[ANGLE] -= DELTA   # rotate by - theta if going the affine transform route
      when 'X'                   # do nothing except recognize 'X' as a word in the L-system grammar
      else 
        puts "Character '#{element}' is not in grammar" 
      end
    end
  end
  
  ##############################
  # create grammar from axiom and
  # rules (adjust scale)
  ##############################
  
  def create_grammar(gen)
    @gen = gen
    @draw_length *= 0.6**gen
    @production = @grammar.generate gen
  end    
  
  private
  ######################################################
  # draws line using current turtle and length parameters
  # returns a turtle corresponding to the new position
  ######################################################
  
  def draw_line(turtle, length)
    new_xpos = turtle[XPOS] + length * Math.cos(turtle[ANGLE])
    new_ypos = turtle[YPOS] + length * Math.sin(turtle[ANGLE])
    line(turtle[XPOS], turtle[YPOS], new_xpos, new_ypos)
    turtle = [new_xpos, new_ypos, turtle[ANGLE]]
  end
end  
  
  
attr_reader :kolam

def setup
  size 500, 500
  @kolam = SnakeKolam.new width/8, height*0.8
  kolam.create_grammar 3          # create grammar from rules
  no_loop
end

def draw
  background 0
  stroke_weight 3
  stroke 200
  kolam.render 
end
  

