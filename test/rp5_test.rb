gem "minitest"      # don't use bundled minitest
require "minitest/autorun"
require "fileutils"
require "tempfile"
require "timeout"
require "thread"

Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)


Dir.chdir(File.dirname(__FILE__))

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
  if frame_count == 3
    exit
  end
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
  if frame_count == 3
    exit
  end
end
EOF
    assert_equal "ok", queue.pop
  end

  
  def test_setup_exception
    queue = write_and_run_sketch <<EOF
def setup
  size(300, 300)
  begin
    unknown_method()
  rescue NoMethodError => e
    println e
    exit
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
    exit
  end
end
EOF
    assert queue.pop.index("undefined method `unknown_method'")
  end
  
  def test_opengl_version
    # uncomment line below to skip this test
    #skip("May need run this test with jruby")
    queue = write_and_run_sketch <<EOF
def setup
  size(100, 100, P3D)
  puts Java::Processing::opengl::PGraphicsOpenGL.OPENGL_VERSION
  exit
end
   
EOF
    result = queue.pop
    assert result[0].to_i >= 3, "Graphics capability #{result} may be sub-optimal" 
  end

  def write_and_run_sketch(sketch_content)
    queue = Queue.new
    sketch_thread = Thread.new do
      Tempfile.open("rp5_tester") do |tf|
        tf.write(sketch_content)
        tf.close
        # FileUtils.cp(tf.path, "/tmp/sketch.rb", :verbose => true)
        output = nil
          open("|../bin/rp5 run #{tf.path}", "r") do |io|
          while l = io.gets
            queue.push(l.chop)
          end
        end
      end
    end
    sketch_thread.join 20
    return queue
  end

end
