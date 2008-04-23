# Specs for the Basic utility functions of the exporters.
# -- omygawshkenas

require 'script/base_exporter'

describe "Processing::BaseExporter" do
  before :all do
    @ex = Processing::BaseExporter.new
    @ex.instance_eval do
      @main_file = "full_screen.rb"
      @main_file_path = "samples/full_screen.rb"
    end
    @info = @ex.extract_information
  end
  
  describe "(extracting information from source code)" do
    
    it "should get the class name" do
      @info[:class_name].should == "FullScreen"
    end
    
    it "should get the title" do
      @info[:title].should == "Full Screen"
    end
    
    it "should get the width" do
      @info[:width].should == "600"
    end
    
    it "should get the height" do
      @info[:height].should == "600"
    end
    
    it "should get the description" do
      @info[:description].should_not be_empty
    end
    
    it "should get the libraries it needs to load" do
      @info[:libs_to_load].should == ["opengl"]
    end
    
    it "should be able to set instance variables" do
      @ex.hash_to_ivars(@info)
      ["@class_name", "@width", "@height", "@description", "@libs_to_load", "@title"].each do |var|
        @ex.instance_variables.should include(var)
      end
    end
    
    it "should extract requires that actually exist" do
      @ex.extract_real_requires(__FILE__).should == ["script/base_exporter.rb"]
    end
  end  
  
  it "should be able to render erb" do
    @mom = "Mom"
    erb = "Hello <%= @mom %>!"
    ans = @ex.render_erb_from_string_with_binding(erb, binding)
    ans.should == "Hello Mom!"
  end
  
end