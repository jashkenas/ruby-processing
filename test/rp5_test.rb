require "minitest/autorun"
require "fileutils"
require "tempfile"
require "timeout"
require "thread"

Dir.chdir(File.dirname(__FILE__))
# for compatibility
Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

class Rp5Test < Minitest::Test
 # OUTPUT_FILE = File.join(Dir.pwd, "output.txt")

  def test_normal    
    queue = write_and_run_sketch <<EOF
def setup
  size(300, 300)
  frame_rate(10)
end

def draw
  println "ok"
  if frame_count == 10
    exit
  end
end
EOF
    10.times do
      assert_equal "ok", queue.pop
    end
  end

  def test_P2D
    queue = write_and_run_sketch <<EOF
def setup
  size(300, 200, P2D)
end

def draw
  println "ok"
  exit
end
EOF
    assert_equal "ok", queue.pop
  end

  def test_P3D
    queue = write_and_run_sketch <<EOF
def setup
  size(300, 300, P3D)
end

def draw
  println "ok"
  exit
end
EOF
    assert_equal "ok", queue.pop
  end

  def test_PDF
    skip("Can cause deadlock...")
    queue = write_and_run_sketch <<EOF
load_library 'pdf'
include_package 'processing.pdf'

def setup
  size(2000, 2000, PDF, "Line.pdf")
end

def draw
  background(255)
  stroke(0, 20)
  strokeWeight(20.0)
  line(200, 0, width/2, height)
  exit  
end
EOF
    assert_equal "created", queue.pop[0, 7]
  end
  
  def test_setup_exception
    queue = write_and_run_sketch <<EOF
def setup
  size(300, 300)
  begin
    unknown_method()
  rescue NoMethodError => e
    println e
  end
end

def draw
end
EOF
    assert queue.pop.index("undefined method `unknown_method'")
  end

  def test_draw_exception
    queue = write_and_run_sketch <<EOF
def setup
  size(300, 300)
end

def draw
  begin 
    unknown_method()
  rescue NoMethodError => e
    println e
  end
end
EOF
    assert queue.pop.index("undefined method `unknown_method'")
  end
  
  def test_inner_classes_proxy
    skip("Need to debug this...")
    queue = write_and_run_sketch <<EOF
def setup
  size(300, 300)
  begin
    MyInnerClass.new 
  rescue
    println("inner class proxy doesn't work")
  end
  exit
end
   
class MyInnerClass
  def initialize
    println(width)
  end
end
EOF
    assert_equal "300", queue.pop
  end


  def write_and_run_sketch(sketch_content)
    queue = Queue.new
    Thread.new do
      Tempfile.open("rp5_tester") do |tf|
        tf.write(sketch_content)
        tf.close
        #FileUtils.cp(tf.path, "/tmp/sketch.rb", :verbose => true)
        output = nil
        begin
          Timeout.timeout(15) do 
            open("|../bin/rp5 run #{tf.path}", "r") do |io|
              while l = io.gets
                queue.push(l.chop)
              end
            end
          end
          assert $?.exited?
        rescue Timeout::Error
          assert false, "rp5 timed out"
        end
      end
    end
    return queue
  end
end
