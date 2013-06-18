#
# Camera Customization.
# by Jean Pierre Charalambos.
# 
# This example shows all the different aspects of proscene that
# can be customized and how to do it.
# 
# Read the commented lines of the sketch code for details.
#
# Press 'h' to display the global shortcuts in the console.
# Press 'H' to display the current camera profile keyboard shortcuts
# and mouse bindings in the console.
#

load_library :proscene



include_package 'remixlab.proscene'
include_package 'remixlab.proscene.Scene'
include_package 'remixlab.proscene.Scene.CameraKeyboardAction'


class WeirdCameraProfile < CameraProfile
  
  def initialize(scn, name)
    super(scn, name)
    # 1. Perform some keyboard configuration (warning: camera profiles override those of the scene):
    # 'u' = move camera up
    setShortcut('u'.ord, Scene::CameraKeyboardAction::MOVE_CAMERA_UP)
    # CTRL + SHIFT + 'l' = move camera to the left
    setShortcut((Event::ALT || Event::SHIFT), 'l'.ord, Scene::CameraKeyboardAction::MOVE_CAMERA_LEFT)
    # 'S' (note the caps) = move the camera to show all the scene
    setShortcut('S'.ord, Scene::CameraKeyboardAction::SHOW_ALL)
    # 2. Describe how to control the camera:
    # mouse left button = translate camera
    setCameraMouseBinding(LEFT.ord, Scene::MouseAction::TRANSLATE)
    # SHIFT + mouse left button = rotate camera
    setCameraMouseBinding(Event::SHIFT, LEFT.ord, Scene::MouseAction::ROTATE);   
    # Right button = zoom on region
    setCameraMouseBinding(RIGHT.ord, Scene::MouseAction::ZOOM_ON_REGION)
    # 3. Describe how to control the interactive frame:
    # Left button = rotate interactive frame
    setFrameMouseBinding(LEFT.ord, Scene::MouseAction::ROTATE)
    # Right button = translate interactive frame
    setFrameMouseBinding(RIGHT.ord, Scene::MouseAction::TRANSLATE)
    # Right button + SHIFT = screen translate interactive frame
    setFrameMouseBinding(Event::SHIFT, RIGHT.ord, Scene::MouseAction::SCREEN_TRANSLATE)
    # 4. Configure some click actions:
    # double click + button left = align frame with world
    setClickBinding(LEFT.ord, 2, Scene::ClickAction::ALIGN_FRAME)
    # single click + middle button + SHIFT + ALT = interpolate to show all the scene
    setClickBinding((Event::SHIFT | Event::ALT), CENTER.ord, 1, Scene::ClickAction::ZOOM_TO_FIT)
    # double click + middle button = align camera with world
    setClickBinding(CENTER.ord, 2, Scene::ClickAction::ALIGN_CAMERA)
  end  
  
end


attr_reader :scene, :wProfile

def setup
  size(640, 360, P3D)
  @scene = Scene.new(self)
  # A Scene has a single InteractiveFrame (null by default). We set it
  # here.
  scene.setInteractiveFrame(InteractiveFrame.new(scene))
  scene.interactiveFrame.translate(PVector.new(30, 30, 0))
  
  # 1. Perform some keyboard configuration:
  # Note that there are some defaults set (soon to be  documented ;)
  # change interaction between camera an interactive frame:
  scene.setShortcut('f'.ord, Scene::KeyboardAction::FOCUS_INTERACTIVE_FRAME)
  # draw frame selection hint
  scene.setShortcut(Event::ALT, 'i'.ord, Scene::KeyboardAction::DRAW_FRAME_SELECTION_HINT)
  # change the camera projection
  scene.setShortcut('z'.ord, Scene::KeyboardAction::CAMERA_TYPE)
  
  # 2. Customized camera profile:
  @wProfile = WeirdCameraProfile.new(scene, "MY_PROFILE")
  scene.registerCameraProfile(wProfile)
  # Unregister the  first-person camera profile (i.e., leave WHEELED_ARCBALL
  # and MY_PROFILE):
  scene.unregisterCameraProfile("FIRST_PERSON")
end

def draw
  background(0)
  fill(204, 102, 0)
  box(20, 20, 40)
  # Save the current model view matrix
  push_matrix
  # Multiply matrix to get in the frame coordinate system.
  # applyMatrix(scene.interactiveFrame.matrix) is handy but
  # inefficient
  scene.interactiveFrame.applyTransformation # optimum
  # Draw an axis using the Scene static function
  scene.drawAxis(20)
  # Draw a second box attached to the interactive frame
  if (scene.interactiveFrame.grabsMouse)
    fill(255, 0, 0)
    box(12, 17, 22)
    
  elsif (scene.interactiveFrameIsDrawn)
    fill(0, 255, 255)
    box(12, 17, 22)
    
  else
    fill(0, 0, 255)
    box(10, 15, 20)
  end
  pop_matrix
end
