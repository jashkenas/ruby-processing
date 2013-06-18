#######################################################
# penrose tiling in ruby processing using LSystems
# in ruby-processing by Martin Prout
######################################################
load_libraries "grammar"

attr_reader :penrose

def setup
  size 800, 800
  stroke_weight 2
  smooth
  @penrose = PenroseColored.new(width/2, height/2)
  penrose.create_grammar 5
  no_loop  
end

def draw
  background 0
  penrose.render
end



#############################
# penrose_colored.rb
#############################

class PenroseColored
  include Processing::Proxy
  import 'grammar'
  
  attr_reader :axiom, :grammar, :start_length, :theta, :production, :draw_length,
  :repeats, :xpos, :ypos
  
  XPOS = 0     # placeholders for pen array
  YPOS = 1
  ANGLE = 2
  COL = 3
  DELTA = PI/5 # radians or 36 degrees
  RED = 70<<24|200<<16|0<<8|0   # using bit operations to set color int
  BLUE = 70<<24|0<<16|0<<8|200
  
  def initialize xpos, ypos                  # Note using abbreviated lsystem grammar 
    @axiom = "[X]2+[X]2+[X]2+[X]2+[X]"       # where numbers, are used to indicate repeats    
    @grammar = Grammar.new(
      axiom,                                 
      {
        "F" => "",                           # a so called deletion rule
        "W" => "YBF2+ZRF4-XBF[-YBF4-WRF]2+", # regular substitution rules ....
        "X" => "+YBF2-ZRF[3-WRF2-XBF]+",
        "Y" => "-WRF2+XBF[3+YBF2+ZRF]-",
        "Z" => "2-YBF4+WRF[+ZRF4+XBF]2-XBF",       
      }
      )
    @start_length = 1000.0
    @theta = 0
    @xpos = xpos
    @ypos = ypos
    @production = axiom
    @draw_length = start_length
  end
  
  ##############################################################################
  # Not strictly in the spirit of either processing in my render
  # function I have ignored the processing translate/rotate functions in favour
  # of the direct calculation of the new x and y positions, thus avoiding such
  # affine transformations.
  ##############################################################################
  
  def render
    repeats = 1
    pen = [xpos, ypos, theta, :R]   # simple array for pen, symbol :R = red
    stack = []                      # simple array for stack
    production.each do |element|
      case element
      when 'F'
        pen = draw_line(pen, draw_length)
      when '+'
        pen[ANGLE] += DELTA * repeats
        repeats = 1
      when '-'
        pen[ANGLE] -= DELTA * repeats
        repeats = 1
      when '['
        stack.push(pen.dup)  # push a copy current pen to stack
      when ']'
        pen = stack.pop      # assign current pen to instance off the stack
      when 'R', 'B'        
        pen[COL] = element.to_sym  # set pen color as symbol
      when 'W', 'X', 'Y', 'Z'  
      when '1', '2', '3', '4'
        repeats = Integer(element)
      else puts "Character '#{element}' not in grammar"
      end
    end
  end
  
  #####################################################
  # create grammar from axiom and # rules (adjust scale)
  #####################################################
  
  def create_grammar(gen)
    @draw_length *= 0.5**gen
    @production = grammar.generate gen
  end
  
  private
  ####################################################################
  # draws line using current pen position, color and length parameters
  # returns a pen corresponding to the new position
  ###################################################################
  
  def draw_line(pen, length)
    stroke (pen[COL] == :R)? RED : BLUE
    new_xpos = pen[XPOS] - length * cos(pen[ANGLE])
    new_ypos = pen[YPOS] - length * sin(pen[ANGLE])
    line(pen[XPOS], pen[YPOS], new_xpos, new_ypos)    # draw line
    return [new_xpos, new_ypos, pen[ANGLE], pen[COL]] # return pen @ new pos
  end
end


