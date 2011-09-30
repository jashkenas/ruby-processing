############################
# Non-stochastic grammar
# with unique premise/rules
############################
class Grammar
  attr_accessor :axiom, :rules

  def initialize axiom
    @axiom = axiom
    @rules = Hash.new
  end

  def add_rule premise, rule
    rules.store(premise, rule)
  end

  ##########################################
  # replace each pre char with a unique rule
  ##########################################
  def new_production production
    production.gsub!(/./) { |c| (r = @rules[c]) ? r : c }
  end

  ##########################################
  # control the number of iterations
  # default 0, returns the axiom
  ##########################################
  def generate repeat = 0
    prod = axiom
    repeat.times do
      prod = new_production prod
    end
    return prod
  end
end

############################
# Hilbert Curves
###########################
class Hilbert
  include Processing::Proxy
  ADJUSTMENT = [0,  0.5,  1.5,  3.5,  7.5, 15]
  attr_reader :grammar, :axiom, :production, :premis, :rule,
  :theta, :distance, :phi, :gen

  def initialize(len)
    @axiom = "X"
    @grammar = Grammar.new(axiom)
    @production = axiom
    @premis = "X"
    @rule = "^<XF^<XFX-F^>>XFX&F+>>XFX-F>X->"
    @distance = len
    @theta = Math::PI/180 * 90
    @phi = Math::PI/180 * 90  
    grammar.add_rule(premis, rule)
  end

  def render()    
    translate( -distance * ADJUSTMENT[gen], distance *  ADJUSTMENT[gen], -distance * ADJUSTMENT[gen])
    fill(0, 75, 152)
    light_specular(204, 204, 204)
    specular(255, 255, 255)
    shininess(1.0)
    production.scan(/./) do |ch|
      case(ch)
      when "F"
        translate(0, distance/-2, 0)
        box(distance/9 , distance, distance/9)
        translate(0, distance/-2, 0)
      when "+"
        rotateX(-theta)
      when "-"
        rotateX(theta)
      when ">"
        rotateY(theta)
      when "<"
        rotateY(-theta)
      when "&"
        rotateZ(-phi)
      when "^"
        rotateZ(phi)
      when "X"
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
    @gen = gen    # required for depth adjustment
    @distance *= 1/(pow(2, gen) - 1)
    @production = @grammar.generate gen
  end
  

end