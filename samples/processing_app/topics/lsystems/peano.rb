########################################################
# A Peano fractal implemented using a
# Lindenmayer System in ruby-processing by Martin Prout
########################################################
load_libraries :grammar, :fastmath, :vecmath

class Peano
  include Processing::Proxy 
  
  attr_reader :draw_length, :vec, :theta, :axiom, :grammar
  DELTA  = 60  # degrees
  def initialize vec
    @axiom = "XF"       # Axiom
    rules = {
      'X' => "X+YF++YF-FX--FXFX-YF+",      # LSystem Rules
      "Y" => "-FX+YFYF++YF+FX--FX-Y"
    }    
    @grammar = Grammar.new(axiom, rules)
    @theta   = 0  
    @draw_length = 100
    @vec = vec
  end
  
  def generate gen
    @draw_length = draw_length * pow(0.6, gen)
    grammar.generate gen
  end
  
  def translate_rules(prod)
    points = []               # An empty array to store line vertices as Vec2D
    prod.each do |ch|
      case ch
      when 'F'
        points << vec.copy << Vec2D.new(vec.x += draw_length * DegLut.cos(theta), vec.y -= draw_length * DegLut.sin(theta))
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

attr_reader :points, :renderer

def setup
  size(800, 800)
  @renderer = AppRender.new(self)
  peano = Peano.new(Vec2D.new(width * 0.65, height * 0.9))
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
  points.each_slice(2) do |v0, v1|
    v0.to_vertex renderer
    v1.to_vertex renderer
  end
  end_shape 
end


