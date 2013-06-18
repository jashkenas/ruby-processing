#
# Cad Camera.
# by Jean Pierre Charalambos.
# 
# This example illustrates how to add a CAD Camera type to your your scene.
# 
# Press 'h' to display the global shortcuts in the console.
# Press 'H' to display the current camera profile keyboard shortcuts
# and mouse bindings in the console.
# Press 'u' to switch between right handed and left handed world frame.
# Press the space bar to switch between camera profiles: CAD and CAD_CAM.
# Press x, y or z to set the main rotation axis (defined in the world
# coordinate system) used by the CAD Camera.
#

load_library :proscene

include_package 'remixlab.proscene'

attr_reader :scene

def setup
  size(640, 360, P3D)
  #Scene instantiation
  @scene = Scene.new(self)
  #Register a CAD Camera profile and name it "CAD_CAM" NB Mode is a java enum
  scene.register_camera_profile(CameraProfile.new(scene, "CAD_CAM", CameraProfile::Mode::CAD))
  #Set the CAD_CAM as the current camera profile
  scene.set_current_camera_profile("CAD_CAM")
  #Unregister the  first-person camera profile (i.e., leave WHEELED_ARCBALL and CAD_CAM)
  scene.unregister_camera_profile("FIRST_PERSON")
  #Set right handed world frame (useful for architects...)
  scene.set_right_handed
  scene.camera.frame.setCADAxis(PVector.new(0, 1, 0))
  scene.camera.frame.set_rotation_sensitivity(1.5)
  scene.camera.frame.set_spinning_friction(0.5)
  scene.camera.frame.set_tossing_friction(0.5)
end

def draw
  background(0)
  fill(204, 102, 0)
  box(20, 30, 50)
end

def key_pressed
  case(key)
  when 'u', 'U'
    ( scene.right_handed? )? scene.set_left_handed : scene.set_right_handed
  when 'x', 'X'
    scene.camera.frame.setCADAxis(PVector.new(1, 0, 0))
  when 'y', 'Y'
    scene.camera.frame.setCADAxis(PVector.new(0, 1, 0))
  when 'z','Z'
    scene.camera.frame.setCADAxis(PVector.new(0, 0, 1))
  end
end
