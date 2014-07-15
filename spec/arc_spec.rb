require_relative "../lib/core"
require_relative "../lib/rpextras"

Java::ProcessingVecmathArcball::ArcballLibrary.new.load(JRuby.runtime, false)

describe "arcball new" do
  it "should give error" do	
    expect { Processing::ArcBall.init}.to raise_error
  end
end


describe "arcball center" do
  it "center pass" do
    Processing::ArcBall.init(Java::ProcessingCore::PApplet.new, 200, 100)
  end
end

##############################
# Failed to mock camera version
###############################
