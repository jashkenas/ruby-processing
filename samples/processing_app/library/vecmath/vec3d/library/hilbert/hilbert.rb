############################
# Simple lsystem grammar
############################
class Grammar
  def initialize(axiom, rules)
    @axiom = axiom
    @rules = rules
  end

  def expand(production, iterations, &block)
    production.each_char do |token|
      if @rules.has_key?(token) && iterations > 0 
        expand(@rules[token], iterations - 1, &block)
      else
        yield token
      end
    end
  end

  def each gen
    expand(@axiom, gen) {|token| yield token }
  end

  def generate gen
    output = []
    each(gen) { |token| output << token }
    output
  end

end


############################
# Hilbert Curves
###########################
class Hilbert
  include Processing::Proxy
  attr_reader :grammar, :axiom, :production, :premis, :rule,
  :theta, :distance, :phi, :gen, :adj_array

  def initialize(size: 1.0, gen: 1)
    @axiom = "X"                                           # AXIOM
    @rule = {"X" => "^<XF^<XFX-F^>>XFX&F+>>XFX-F>X->"}     # RULE
    @gen = gen
    @grammar = Grammar.new(axiom, rule) 
    @production = grammar.generate gen
    @distance = size / (gen**2 - 1)
    @theta = radians 90
    @phi = radians 90  
    @adj_array = [0,  0.5,  1.5,  3.5,  7.5, 15].map{|x| Vec3D.new(x * -1, x, x * -1)}

  end

  def draw    
    #translate( -distance * ADJUSTMENT[gen], distance *  ADJUSTMENT[gen], -distance * ADJUSTMENT[gen])
    adj = adj_array[gen] * distance
    translate(adj.x, adj.y, adj.z)
    fill(0, 75, 152)
    light_specular(204, 204, 204)
    specular(255, 255, 255)
    shininess(1.0)
    production.each do |ch|
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

end   
