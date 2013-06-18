####################################################
# The DavidTour fractal has been used to study the
# Euclidean travelling salesman problem
####################################################
load_library :grammar

class DavidTour
  import 'grammar'
  attr_reader :draw_length, :xpos, :ypos, :theta, :axiom, :grammar
  DELTA = Math::PI/3 # 60 degrees
  
  def initialize xpos, ypos
    @axiom = "FX-XFX-XFX-XFX-XFX-XF"   # Axiom
    @theta  = 0
    @grammar = Grammar.new(
      axiom,
      {
        "F" => "!F!-F-!F!",            # Rules
        "X" => "!X"      
      }
      )
    @draw_length = 15
    @xpos = xpos
    @ypos = ypos
  end
  
  def create_grammar(gen)  
    @draw_length *= draw_length * 0.5**gen
    grammar.generate(gen)
  end
  
  def translate_rules(prod)
    swap = false
    points = [] # An empty array to store lines as a flat array of points
    prod.each do |ch|
      case(ch)
      when 'F'
        points << xpos << ypos << (@xpos += draw_length * Math.cos(theta)) << (@ypos -= draw_length * Math.sin(theta))         
      when '+'
        @theta += DELTA      
      when '-'
        @theta += swap ? DELTA : -DELTA
      when '!'
        swap = !swap
      when 'X'    
      else
        puts("character '#{ch}' not in grammar")
      end
    end
    return points
  end
end



########################################################
# A David Tour fractal implemented using a
# Lindenmayer System in ruby-processing by Martin Prout
########################################################

attr_reader :points

def setup
  size(800, 900)
  david = DavidTour.new(width * 0.6, height/4)
  production = david.create_grammar(5)
  @points = david.translate_rules(production)
  no_loop()
end

def draw()
  background(0)
  stroke(255)
  points.each_slice(4) do |point|
    line(*point)
  end
end
