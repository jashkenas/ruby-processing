# Make sure that the .jars are signed proper.
# -- omygawshkenas

describe "Signed Jars" do
  
  it "should verify core.jar" do
    s = `jarsigner -verify -certs core.jar`
    s.should =~ /jar verified/
  end
  
  it "should verify jruby-complete.jar" do
    s = `jarsigner -verify -certs script/base_files/jruby-complete.jar`
    s.should =~ /jar verified/
  end
  
end