require "test/unit"
require "fileutils"
require "tempfile"
require "timeout"

Dir.chdir(File.dirname(__FILE__))

class Rp5Test < Test::Unit::TestCase
  OUTPUT_FILE = File.join(Dir.pwd, "output.txt")
  
  def test_normal
    FileUtils.rm_f(OUTPUT_FILE)
    output = write_and_run_sketch <<EOF
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
    assert_equal "ok\n"*10, output
  end

  def test_opengl
    output = write_and_run_sketch <<EOF
load_library "opengl"

def setup
  size(300, 300, OPENGL)
end

def draw
  println "ok"
  exit
end
EOF
    assert_equal "ok\n", output
  end

  def test_setup_exception
    output = write_and_run_sketch <<EOF
def setup
  size(300, 300)
  unknown_method()
end

def draw
end
EOF
    assert output.index("undefined method `unknown_method'")
  end

  def test_draw_exception
    output = write_and_run_sketch <<EOF
def setup
  size(300, 300)
end

def draw
  unknown_method()
end
EOF
    assert output.index("undefined method `unknown_method'")
  end
  
  def test_rp5_watch
    tf = Tempfile.new("rp5_watch_tester")
    sketch_source = <<EOF
    def setup
      size(200, 200)
    end

    def draw
      println "ok"
      no_loop
    end
EOF
    tf.write(sketch_source)
    tf.close
    lines = []
    watcher_thread = Thread.new do 
      open("|../bin/rp5 watch #{tf.path}", "r") do |io|
        while l = io.gets
          lines << l
        end
      end
    end
    sleep 10
    assert_equal "ok\n", lines.shift
    File.open(tf.path, "w") { |f| f.puts(sketch_source.sub(/no_loop/, "exit")) }
    sleep 5
    assert_equal "reloading sketch...\n", lines.shift
    assert_equal "ok\n", lines.shift
    # terminated normally
    assert_equal false, watcher_thread.status
    assert lines.empty?
  end

  def write_and_run_sketch(sketch_content)
    Tempfile.open("rp5_tester") do |tf|
      tf.write(sketch_content)
      tf.close
      #FileUtils.cp(tf.path, "/tmp/sketch.rb", :verbose => true)
      output = nil
      begin
        Timeout.timeout(15) do 
          output = `../bin/rp5 run #{tf.path} 2>&1`
        end
        assert $?.exited?
      rescue Timeout::Error
        assert false, "rp5 timed out"
      end
      return output
    end
  end
end
