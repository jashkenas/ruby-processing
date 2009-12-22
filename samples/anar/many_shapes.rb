# Demonstrates custom shapes with the Anar library.
# Hold down middle button to control orientation
# of the working surface (prepare to be amazed)!

load_libraries 'anar', 'opengl'
import "anar"
import "processing.opengl"
full_screen

def setup
  setup_opengl
  Anar.init self
  Anar.draw_axis
  Face.globalRender = RenderFaceNormal.new(OogColor.new(255, 100), OogColor.new(100))
  create_shapes
end

def create_shapes
  @scene = Obj.new
  @group = Group.new
  shapes = []

  # A Cone.
  cone = Cone.new(50,100,20)
  cone.set("cone")
  cone.translate(100,100,0)
  @group.add(cone)
  shapes << cone
  # puts(cone.to_obj_exporter)

  # A Box.
  box = Box.new(10,20,30)
  box.set("box")
  box.rotate_z(0)
  box.rotate_x(0)
  box.translate(100, 0, 0)
  @group.add(box)
  shapes << box
  # puts(box.to_obj_exporter("box"))
  # puts(box.parent_list(-1))

  # A Cylinder
  cylinder = Cylinder.new(50, 24, 50)
  cylinder.set("cylinder")
  cylinder.translate(-100, 0, 0)
  @group.add(cylinder)
  shapes << cylinder
  # puts(cylinder.to_obj_exporter("cylinder"))

  # An ellipse.
  ellipse = Ellipse.new(40, 20)
  ellipse.set("ellipse")
  @group.add(ellipse)
  shapes << ellipse
  # puts(ellipse.to_obj_exporter("ellipse"))

  # A 3D Swiss Cross.
  swiss_cross = SwissCross3D.new(10, 10)
  swiss_cross.set("swiss_cross")
  #swiss_cross.fill(255,0,0,200)
  #swiss_cross.translate(-100,0,0)
  @group.add(swiss_cross)
  shapes << swiss_cross
  # puts(swiss_cross.to_obj_exporter("swiss_cross"))

  # A Revolver
  control_line = Pts.new()
  control_line.add(Anar.Pt(30,0,30))
  control_line.add(Anar.Pt(10,0,40))
  control_line.add(Anar.Pt(20,0,60))
  control_line.add(Anar.Pt(20,0,70))
  revolver = Revolve.new(control_line, Anar.Pt(0,0,20), 12)
  revolver.set("revolver")
  @group.add(revolver)
  shapes << revolver
  # puts(revolver.to_obj_exporter("revolver"))

  # Add all the shapes to the scene.
  shapes.each {|shape| @scene.add(shape) }
  Anar.sliders(swiss_cross)
  Anar.sliders(revolver)
  Anar.cam_target(revolver)
end

def setup_opengl
  render_mode OPENGL
  hint ENABLE_OPENGL_4X_SMOOTH     # optional
  hint DISABLE_OPENGL_ERROR_REPORT # optional
end

def draw
  background 155
  @group.draw
end

def key_pressed
  create_shapes if key == ' '
end
