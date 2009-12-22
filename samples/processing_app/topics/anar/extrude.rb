################################################
# extrude.rb is a processing sketch that shows
# how you can use the anar library in ruby processing
# see README.txt for more details
################################################

load_libraries 'anar', 'opengl'
import "anar" if library_loaded? "anar"
import "processing.opengl" if library_loaded? "opengl"

attr_accessor :my_obj
full_screen

def setup()
  library_loaded?(:opengl) ? setup_opengl : fail_opengl
  frame_rate(200)

  Anar.init(self)
  Anar.draw_axis(true)

  init_form()
end

def setup_opengl
  render_mode OPENGL
  hint ENABLE_OPENGL_4X_SMOOTH #optional
  hint DISABLE_OPENGL_ERROR_REPORT #optional
end

def init_form()

  #Create a new Line
  pts = Pts.new

  pts.add(Anar.Pt(100,110,20))
  pts.add(Anar.Pt(110,100,40))
  pts.add(Anar.Pt(110,90,60))
  pts.add(Anar.Pt(90,90,90))
  #Create a Face
  f = Star.new(50,100,5)
  #Extrude the face along the Line
  @my_obj = Extrude.new(f,pts)
  Anar.cam_target(my_obj)
  Anar.sliders(my_obj)
end

def draw()
  background(155)
  my_obj.draw()
end

def fail_opengl
  abort "!!!You absolutely need opengl for this sketch!!!"
end

#Toggle the display of the sliders
def keyPressed()
  Anar.sliders_toggle()
end
