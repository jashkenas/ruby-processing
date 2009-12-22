################################################
# many_forms.rb is a processing sketch that shows
# how you can use the anar library in ruby processing
# see README.txt for more details
# hold down middle button to control orientation
# of the working surface (prepare to be amazed!!!)
################################################

load_libraries 'anar', 'opengl'
import "anar" if library_loaded? "anar"
import "processing.opengl" if library_loaded? "opengl"

attr_accessor :my_obj, :group
full_screen

def setup()
  library_loaded?(:opengl) ? setup_opengl : fail_opengl
  Anar.init(self)
  Anar.draw_axis()
  Face.globalRender = RenderFaceNormal.new(OogColor.new(255, 100), OogColor.new(100))
  init_form()
end

def init_form()
  @my_obj = Obj.new
  @group = Group.new

  ###################
  #CONE
  ###################
  cone = Cone.new(50,100,20)
  cone.set("cone")
  cone.translate(100,100,0)

  puts(cone.to_obj_exporter())
  group.add(cone)

  ###################
  #BOX
  ###################
  box = Box.new(10,20,30)
  box.set("box")
  box.rotate_z(0)
  box.rotate_x(0)
  box.translate(100, 0, 0)
  puts(box.to_obj_exporter("box"))
  puts(box.parent_list(-1))
  group.add(box)

  ###################
  #CYLINDER
  ###################
  cylinder = Cylinder.new(50, 24, 50)
  cylinder.set("cylinder")
  cylinder.translate(-100, 0, 0)
  puts(cylinder.to_obj_exporter("cylinder"))
  group.add(cylinder)

  ###################
  #ELLIPSE
  ###################
  ellipse = Ellipse.new(40, 20)
  ellipse.set("ellipse")
  puts(ellipse.to_obj_exporter("ellipse"))
  group.add(ellipse)

  ###################
  #SWISSCROSS3D
  ###################
  swissCross3D = SwissCross3D.new(10, 10)
  swissCross3D.set("swissCross3D")
  #swissCross3D.fill(255,0,0,200)
  puts(swissCross3D.to_obj_exporter("swissCross3D"))
  #swissCross3D.translate(-100,0,0)
  group.add(swissCross3D)

  ###################
  #REVOLVER
  ###################
  ctrlRevol = Pts.new()
  ctrlRevol.add(Anar.Pt(30,0,30))
  ctrlRevol.add(Anar.Pt(10,0,40))
  ctrlRevol.add(Anar.Pt(20,0,60))
  ctrlRevol.add(Anar.Pt(20,0,70))
  revolver = Revolve.new(ctrlRevol, Anar.Pt(0,0,20), 12)    
  revolver.set("revolver")
  puts(revolver.to_obj_exporter("revolver"))
  group.add(revolver)

  ##################
  ################### 
  my_obj.add(box)
  my_obj.add(cone)
  my_obj.add(cylinder)
  my_obj.add(ellipse)
  my_obj.add(swissCross3D)
  my_obj.add(revolver)
  Anar.sliders(swissCross3D)
  Anar.sliders(revolver)
  Anar.cam_target(revolver)  
end

def fail_opengl
  abort "!!!You absolutely need opengl for this sketch!!!"
end

def setup_opengl
  render_mode OPENGL
  hint ENABLE_OPENGL_4X_SMOOTH #optional
  hint DISABLE_OPENGL_ERROR_REPORT #optional
end

#PFont font

def draw()
  background(155)
  group.draw()
end

def key_pressed()
    if(key==' ') then 
      init_form
    end
end
