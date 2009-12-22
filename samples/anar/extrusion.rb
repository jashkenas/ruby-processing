# extrude.rb is a processing sketch that shows
# how you can use the Anar library in Ruby-Processing.

load_libraries 'anar', 'opengl'
import "anar"
import "processing.opengl"
full_screen

def setup
  configure_opengl
  configure_anar
  @points = [
    [100,  110,  20],
    [110,  100,  40],
    [110,  90,   60],
    [90,   90,   90]
  ]
  create_extrusion
end

def configure_opengl
  render_mode OPENGL
  hint ENABLE_OPENGL_4X_SMOOTH     # optional
  hint DISABLE_OPENGL_ERROR_REPORT # optional
end

def configure_anar
  Anar.init self
  Anar.draw_axis true
end

def create_extrusion
  pts = Pts.new
  @points.each {|xyz| pts.add(Anar.Pt(*xyz)) } # make a line out of points
  face = Star.new(50,100,5)                    # make a face
  @extrusion = Extrude.new(face, pts)          # extrude the face along the line
  Anar.cam_target(@extrusion)
  Anar.sliders(@extrusion)
end

def draw
  background 155
  @extrusion.draw
end

# show or hide the sliders
def key_pressed
  Anar.sliders_toggle
end
