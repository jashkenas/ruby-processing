# Specs for Ruby-Processing. You can run these with the 
# JRuby version of RSpec. Sweet.

require 'ruby-processing'

describe Processing::App do
  before :all do
    @app = Processing::App.new(:width => 550, :height => 450, :title => "TestApp")
  end
  
  after :all do
    @app.exit
  end
  
  it "should have a width and height" do
    @app.width.should == 550
    @app.height.should == 450
  end
  
  it "should have a title" do
    @app.title.should == "TestApp"
  end
  
  it "should redefine underscored events to camelcased ones" do
    [:mouse_clicked, :mouse_pressed, :key_pressed, :mouse_dragged, :mouse_moved, :key_released].each do |meth_name|
      @app.class.class_eval do
        define_method(meth_name) {}
      end
    end
    @app.methods.should include("mouseClicked", "mousePressed", "keyPressed", "mouseDragged", "mouseMoved", "keyReleased")
  end
  
  it "should be able to get a handle to the current app" do
    Processing::App.current.should == @app
  end
  
  it "should be able to tell when a library has not been loaded" do
    @app.library_loaded?(:boids).should == false
  end
  
  it "should be able to load a Ruby library" do
    @app.class.load_ruby_library(:boids).should == true
  end
  
  it "should be able to tell whether a library has been loaded" do
    @app.library_loaded?(:boids).should == true
  end
  
  it "should come with empty setup and draw methods" do
    @app.methods.should include("setup", "draw")
    @app.setup.should == nil
    @app.draw.should == nil
  end
  
  it "should be able to find methods" do
    @app.find_method(:oval).should == ["oval"]
    @app.find_method("oval").should == ["oval"]
    @app.find_method(/oval/).should == ["oval"]
  end
  
  it "should be able to have a slider" do 
    lambda {
      @app.class.has_slider(:test, 0..50)
    }.should_not raise_error
    lambda {
      @app.class.has_slider(:hello, -50..-200)
    }.should raise_error
  end
  
  it "should be able to access the sliders" do
    @app.class.slider_frame.sliders.size == 1
  end
  
  
  it "should be able to call Processing methods" do
    lambda {
      @app.smooth
      @app.background 10, 0.5
      @app.fill 255
      @app.oval 10, 10, 100, 100
      @app.rect 50, 50, 200, 5
    }.should_not raise_error
  end
  
end