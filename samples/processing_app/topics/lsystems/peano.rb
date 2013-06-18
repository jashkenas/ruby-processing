########################################################
# A Peano fractal implemented using a
# Lindenmayer System in ruby-processing by Martin Prout
########################################################
load_library 'grammar'

class Peano
  include Processing::Proxy
  import 'grammar'
  
  
  attr_reader :draw_length, :xpos, :ypos, :theta, :axiom, :grammar
  DELTA  = PI/3    # 60 degrees
  def initialize xpos, ypos
    @axiom = "XF"       # Axiom
    rules = {
      'X' => "X+YF++YF-FX--FXFX-YF+",      # LSystem Rules
      "Y" => "-FX+YFYF++YF+FX--FX-Y"
    }    
    @grammar = Grammar.new(axiom, rules)
    @theta   = 0  
    @draw_length = 100
    @xpos = xpos
    @ypos = ypos
  end
  
  def generate gen
    @draw_length = draw_length * pow(0.6, gen)
    grammar.generate gen
  end
  
  def translate_rules(prod)
    points = []               # An empty array to store line vertices
    prod.each do |ch|
      case ch
      when 'F'
        points << xpos << ypos << (@xpos += draw_length * cos(theta)) << (@ypos -= draw_length * sin(theta))
      when '+'
        @theta += DELTA        
      when '-'
        @theta -= DELTA        
      when 'X', 'Y'        
      else
        puts("character  #{ch} not in grammar")        
      end      
    end
    return points
  end
end

attr_reader :points

def setup
  size(800, 800)
  peano = Peano.new(width * 0.65, height * 0.9)
  production = peano.generate 4                  # 4 generations looks OK
  @points = peano.translate_rules(production)  
  no_loop
end

def draw
  background(0)
  render points
end

def render points
  no_fill
  stroke 200.0
  stroke_weight 3
  begin_shape
  points.each_slice(4) do |x0, y0, x1, y1|
    vertex x0, y0
    vertex x1, y1
  end
  end_shape 
end


