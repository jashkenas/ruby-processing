########################################################
# A MPeano fractal implemented using a
# Lindenmayer System in ruby-processing by Martin Prout
########################################################
load_library 'grammar'
####################################################
# The MPeano fractal has been used to study the 
# Euclidean travelling salesman problem
####################################################
class MPeano
  include Processing::Proxy
  import 'grammar'
  
  SQRT2 = Math.sqrt(2.0)
  ISQRT2 = 1/SQRT2
  
  attr_reader :draw_length, :xpos, :ypos, :theta, :axiom, :grammar, :delta
  
  def initialize xpos, ypos
    @axiom = "XFF--AFF--XFF--AFF"       # Axiom
    rules = {
      "X" => "+!X!FF-BQFI-!X!FF+",      # LSystem Rules
      "F" => "",                        # Example of a 'delete' replace
      "Y" => "FFY",
      "A" => "BQFI",
      "B" => "AFF"
    }    
    @grammar = Grammar.new(axiom, rules)
    @delta   = QUARTER_PI          # 45 degrees
    @theta   = HALF_PI
    @draw_length = 8
    @xpos = xpos
    @ypos = ypos
  end
  
  def generate gen
    grammar.generate gen
  end
  
  def translate_rules(prod)
    points = []               # An empty array to store line vertices
    prod.each do |ch|
      case(ch)
      when "F"        
        points << xpos << ypos << (@xpos -= draw_length * cos(theta)) << (@ypos -= draw_length * sin(theta)) 
      when "+"
        @theta += delta    
      when "-"
        @theta -= delta   
      when "!"
        @delta = -delta
      when "I"
        @draw_length *= ISQRT2    
      when "Q"
        @draw_length *= SQRT2    
      when "X", "A", "B"     
      else
        puts("character '#{ch}' not in grammar")
      end
    end
    return points
  end
end

attr_reader :points

def setup
  size(600, 600)
  mpeano = MPeano.new(width/2, height*0.95)
  production = mpeano.generate 7                  # 7 generations looks OK
  @points = mpeano.translate_rules(production)
  no_loop
end

def draw
  background(0)
  stroke(255)
  points.each_slice(4) do |point|
    line(*point)
  end
end


