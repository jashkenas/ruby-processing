########################################################
# A 3D Hilbert fractal implemented using a
# Lindenmayer System in ruby-processing by Martin Prout
# Best if you've got opengl
########################################################

class Hilbert_Test < Processing::App
  full_screen # NB: All distances are relative to screen height
  load_libraries 'hilbert', 'PeasyCam', 'opengl'
  import 'peasy'
  import "processing.opengl" if library_loaded? "opengl"
  attr_reader :hilbert, :cam

  def setup
    library_loaded?(:opengl) ? configure_opengl : render_mode(P3D)
    configure_peasycam
    @hilbert = Hilbert.new(height)
    hilbert.create_grammar 3
    no_stroke
  end

  def configure_peasycam
    cam = PeasyCam.new self, height / 6.5
    cam.set_minimum_distance height / 10
    cam.set_maximum_distance height
  end

  def configure_opengl
    render_mode OPENGL
    hint ENABLE_OPENGL_4X_SMOOTH     # optional
    hint DISABLE_OPENGL_ERROR_REPORT # optional
  end

  def draw
    background 0
    lights
    hilbert.render
  end
end

