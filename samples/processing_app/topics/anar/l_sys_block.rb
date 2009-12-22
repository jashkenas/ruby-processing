################################################
# l_sys_block.rb is a processing sketch that shows
# how you can use the lsys features of the anar 
# library in ruby processing see README.txt for 
# more details
################################################


load_libraries 'anar', 'opengl'
import "anar" if library_loaded? "anar"
import "lsys.Grammar" if library_loaded? "anar"
import "processing.opengl" if library_loaded? "opengl"

full_screen

attr_accessor :my_obj, :grammar, :box, :ts, :tf, :init_t, :rot, :sz

def setup()
  library_loaded?(:opengl) ? setup_opengl : fail_opengl
  hint(ENABLE_OPENGL_4X_SMOOTH)
  hint(DISABLE_OPENGL_ERROR_REPORT)
  Anar.init(self)
  Anar.draw_axis(true)
  init_grammar()
  interpret_init()
end

def init_grammar() 
  @grammar = Grammar.new("bt")
  # here define the rules
  # * means any kind of symbol
  # the example rules below are therefore non contextual
  grammar.add_rule("*b*", "brb")
  grammar.add_rule("*t*", "rssb")
  grammar.add_rule("*r*", "rs")
  grammar.add_rule("*s*", "s")
  # this one makes it context dependant
  #	grammar.add_rule("sss", "ss")
  puts(grammar)
end


def interpret_init
  # base element
  @box = Box.new(10, 10, 50)
  # initial position
  @init_t = Translate.new(0, 50, 0)
  # base transformations
  @ts = Translate.new(Anar.Pt(0, 10, -0.001))
  @rot = RotateZ.new(0.5)
  @sz = Scale.new(Anar.Pt(0.99, 0.99, 0.99))
  interpret_grammar()		
end

def interpret_grammar() 
  @my_obj = Obj.new
  @tf = Transform.new(init_t)

  grammar.num_of_symbols.times do |i|

    case(grammar.symbol(i)[0].chr) # todo this is bit of hack, I need understand grammar better
    when 'b'
      my_copy = Obj.new(box, tf)
      my_obj.add(my_copy)
      @tf = Transform.new(tf)
    when 't'
      tf.apply(ts)
    when 'r'
      tf.apply(rot)
    when 's'
      tf.apply(sz)
    else
      puts "grammar not understood"
    end
  end
  Anar.cam_target(my_obj)
end

def draw() 
  background(153)
  my_obj.draw()
end


def key_pressed()
  if(key==' ') 
    grammar.step()
    interpret_grammar()
    puts(grammar)
  end
  if(key=='r') 
    grammar.reset()
    interpret_init()
    interpret_grammar()
    puts(grammar)
  end
  if(key=='p') 
    save_frame("block.png")
  end
  if (key=='g')
    puts grammar.methods
  end
end

def setup_opengl
  render_mode OPENGL
  hint ENABLE_OPENGL_4X_SMOOTH #optional
end
               

def fail_opengl
  abort "!!!You absolutely need opengl for this sketch!!!"
end
