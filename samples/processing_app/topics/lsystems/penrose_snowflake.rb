load_library 'grammar'

class PenroseSnowflake
  include Processing::Proxy
  import 'grammar'

  attr_accessor :axiom, :grammar, :start_length, :theta, :production, :draw_length,
    :repeats, :xpos, :ypos
  DELTA = Math::PI / 10 # 18 degrees as radians

  def initialize xpos, ypos
    @axiom = "F3-F3-F3-F3-F"
    @grammar = Grammar.new( axiom,
    {"F" => "F3-F3-F45-F++F3-F"}
    )
    @start_length = 450.0
    @theta = 0
    @xpos = xpos
    @ypos = ypos
    @draw_length = start_length
  end

  ##############################################################################
  # Parses the production string, and draws a line when 'F' is found, uses
  # trignometry to calculate dx and dy rather than processing transforms
  ##############################################################################

  def render
    repeats = 1
    production.each do |element|
      case element
      when 'F'
        line(xpos, ypos, (@xpos -= multiplier(repeats, :cos)), (@ypos += multiplier(repeats, :sin)))
        repeats = 1
      when '+'
        @theta += DELTA * repeats
        repeats = 1
      when '-'
        @theta -= DELTA * repeats
        repeats = 1
      when '3', '4', '5'
        repeats += element.to_i
      else
        puts "Character '#{element}' is not in grammar"
      end
    end
  end

  ##########################################
  # adjust draw length with number of repeats
  # uses grammar to set production string 
  # see 'grammar.rb'
  ##########################################

  def create_grammar(gen)
    @draw_length *= 0.4**gen
    @production = grammar.generate gen
  end
  
  ###########################################
  # a helper method that returns dx or dy with type & repeat
  # multiplier after Dan Mayer
  ###########################################

  def multiplier(repeats, type)
    value = draw_length * repeats
    # using equal? for identity comparison
    (type.equal? :cos)?  value * cos(theta) : value *  sin(theta)
  end
end

##
# Lindenmayer System in ruby-processing by Martin Prout
# Very loosely based on a processing Penrose L-System
# by Geraldine Sarmiento
###

attr_reader :penrose

def setup
  size 1000, 900
  stroke 255
  @penrose = PenroseSnowflake.new width * 0.8, height * 0.95
  penrose.create_grammar 4
  no_loop    
end

def draw
  background 0
  penrose.render
end


