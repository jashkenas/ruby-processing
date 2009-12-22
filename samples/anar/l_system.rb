# Demonstrates how you can use the Lindenmeyer System (lsys)
# features of the Anar library in Ruby-Processing.
# Press space to draw further iterations of the system.

load_libraries 'anar', 'opengl'
import "anar"
import "lsys.Grammar"
import "processing.opengl"
full_screen

def setup
  setup_opengl
  Anar.init self
  Anar.draw_axis true
  create_grammar
  create_scene
end

def create_grammar
  @grammar = Grammar.new("bt")
  # Here we define the rules.
  # "*" means any kind of symbol.
  # The example rules below are non-contextual.
  @grammar.add_rule("*b*", "brb")
  @grammar.add_rule("*t*", "rssb")
  @grammar.add_rule("*r*", "rs")
  @grammar.add_rule("*s*", "s")
  # The following rule makes it context-sensitive.
  #	grammar.add_rule("sss", "ss")
  puts @grammar
end

def create_scene
  @box    = Box.new(10, 10, 50)                     # the base element
  @pos    = Translate.new(0, 50, 0)                 # with position
  @trans  = Translate.new(Anar.Pt(0, 10, -0.001))   # and transformations...
  @rot    = RotateZ.new(0.5)
  @scale  = Scale.new(Anar.Pt(0.99, 0.99, 0.99))
  interpret_grammar
end

def interpret_grammar
  @scene = Obj.new
  @root  = Transform.new(@pos)
  @grammar.num_of_symbols.times do |i|
    rule = @grammar.symbol(i)[0].chr
    case rule # todo this is bit of hack, I need understand grammar better
    when 'b'
      @scene.add(Obj.new(@box, @root))
      @root = Transform.new(@root)
    when 't' then @root.apply(@trans)
    when 'r' then @root.apply(@rot)
    when 's' then @root.apply(@scale)
    else
      puts "rule: '#{rule}' is not in grammar"
    end
  end
  Anar.cam_target @scene
end

def draw
  background 153
  @scene.draw
end

def key_pressed
  case key
  when ' '
    @grammar.step
    interpret_grammar
    puts @grammar
  when 'r'
    @grammar.reset
    create_grammar
    interpret_grammar
    puts @grammar
  when 'p'
    save_frame "block.png"
  end
end

def setup_opengl
  render_mode OPENGL
  hint ENABLE_OPENGL_4X_SMOOTH     # optional
  hint DISABLE_OPENGL_ERROR_REPORT # optional
end
