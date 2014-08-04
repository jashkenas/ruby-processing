########################################################
# csplant.rb
# A 3D Plant implemented using a Context Sensitive
# Lindenmayer System in ruby-processing 
# by Martin Prout (30 January 2013)
# Hold down 'y' key and drag mouse to rotate about y axis
########################################################

load_libraries :cs_grammar, :vecmath, :fastmath
attr_reader :csplant

def setup
  size 800, 800, P3D
  ArcBall.init(self)
  @csplant = CSPlant.new(height)
  csplant.create_grammar 5
  no_stroke
end

def draw
  background 0
  lights
  translate(0, height*0.3)
  csplant.render
end

############
# CSPlant 
############

class CSPlant
  include Processing::Proxy

  IGNORE = '[]+-^&3'
  attr_reader :grammar, :axiom, :production, :premis, :rule,
  :theta, :scale_factor, :len, :phi, :len

  def initialize(len)
    @axiom = 'F'
    @grammar = Grammar.new(
      axiom,
      {
        'F' => 'F[-EF[3&A]]E[+F[3^A]]',        
        'F<E' => 'F[&F[3+A]][^F[3-A]]'
      },
      IGNORE
    )
    @production = axiom
    @len = len
    @theta = 25.radians
    @phi = 25.radians
    no_stroke
  end

  def render
    fill(0, 75, 152)
    light_specular(204, 204, 204)
    specular(255, 255, 255)
    shininess(1.0)
    repeat = 1
    production.each_char do |ch|
      case ch
      when 'F'
        translate(0, len / -2, 0)
        box(len / 9, len, len / 9)
        translate(0, len / -2, 0)
      when '+'
        rotateX(-theta * repeat)
        repeat = 1
      when '-'
        rotateX(theta * repeat)
        repeat = 1
      when '&'
        rotateZ(-phi * repeat)
        repeat = 1
      when '^'
        rotateZ(phi * repeat)
        repeat = 1
      when '3'
        repeat = 3
      when '['
        push_matrix
      when ']'
        pop_matrix
      when 'E', 'A'
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
