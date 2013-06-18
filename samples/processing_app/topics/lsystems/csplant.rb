########################################################
# csplant.rb
# A 3D Plant implemented using a Context Sensitive
# Lindenmayer System in ruby-processing 
# by Martin Prout (30 January 2013)
########################################################

attr_reader :csplant

def setup
  size 800, 800, P3D
  @csplant = CSPlant.new(height)
  csplant.create_grammar 5
  no_stroke
end

def draw
  background 0
  lights
  translate(width/2, height*0.8)
  rotate_y QUARTER_PI
  csplant.render
end

############
# CSPlant 
############

load_libraries 'cs_grammar'

class CSPlant
  include Processing::Proxy
  import 'cs_grammar'
  IGNORE = "[]+-^&3"
  attr_reader :grammar, :axiom, :production, :premis, :rule,
  :theta, :scale_factor, :len, :phi, :len

  def initialize(len)
    @axiom = "F"
    @grammar = Grammar.new(
      axiom,
      {
        "F" => "F[-EF[3&A]]E[+F[3^A]]",        
        "F<E" => "F[&F[3+A]][^F[3-A]]"      
      },
      IGNORE      
    )
    @production = axiom
    @len = len
    @theta = radians 25
    @phi = radians 25
    no_stroke()
  end

  def render()
    fill(0, 75, 152)
    light_specular(204, 204, 204)
    specular(255, 255, 255)
    shininess(1.0)
    repeat = 1
    production.each_char do |ch|
      case(ch)
      when "F"
        translate(0, len/-2, 0)
        box(len/9, len, len/9)
        translate(0, len/-2, 0)
      when "+"
        rotateX(-theta * repeat)
        repeat = 1
      when "-"
        rotateX(theta * repeat)
        repeat = 1
      when "&"
        rotateZ(-phi * repeat)
        repeat = 1
      when "^"
        rotateZ(phi * repeat)
        repeat = 1
      when "3"
        repeat = 3
      when "["
        push_matrix
      when "]"
        pop_matrix
      when "E", "A"
      else
        puts("character '#{ch}' not in grammar")
      end
    end
  end
  ##############################
  # create grammar from axiom and
  # rules (adjust scale)
  ##############################

  def create_grammar(gen)
    @len *= 0.6**gen
    @production = grammar.generate gen
  end
end
