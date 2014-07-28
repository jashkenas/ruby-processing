gem 'minitest'      # don't use bundled minitest
require 'minitest/autorun'

Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

Dir.chdir(File.dirname(__FILE__))

class Rp5Test < Minitest::Test

  def test_normal
    out, _err_ = capture_io do
      open('|../bin/rp5 run basic.rb', 'r') do |io|
        while l = io.gets
          puts(l.chop)
        end
      end
    end
    assert_match(/ok/, out, 'Failed Basic Sketch')
 end

  def test_p2d
    out, _err_ = capture_io do
      open('|../bin/rp5 run p2d.rb', 'r') do |io|
        while l = io.gets
          puts(l.chop)
        end
      end
    end
    assert_match(/ok/, out, 'Failed P2D sketch')
  end

  def test_proc_root
    require 'psych'
    path = File.expand_path('~/.rp5rc')
    config = File.exist?(path)? Psych.load_file(path) : {}
    root = config.empty? ? '' : config['PROCESSING_ROOT']
    assert root =~ /processing/, 'You need to set your PROCESSING_ROOT in .rp5rc'
  end


  def test_p3d
    out, _err_ = capture_io do
      open('|../bin/rp5 run p3d.rb', 'r') do |io|
        while l = io.gets
          puts(l.chop)
        end
      end
    end
    assert_match(/ok/, out, 'Failed P3D sketch')
  end

  def test_graphics
    out, _err_ = capture_io do
      open('|../bin/rp5 run graphics.rb', 'r') do |io|
        while l = io.gets
          puts(l.chop)
        end
      end
    end
    assert out[0].to_i >= 3, "Graphics capability #{out} may be sub-optimal"
  end

  def test_setup_exception
    out, _err_ = capture_io do
      open('|../bin/rp5 run setup_ex.rb', 'r') do |io|
        while l = io.gets
          puts(l.chop)
        end
      end
    end
    assert out.index("undefined method `unknown_method'"), 'Failed to raise exception?'
  end

  def test_vector
      out, _err_ = capture_io do
      open('|../bin/rp5 run vector.rb', 'r') do |io|
        while l = io.gets
          puts(l.chop)
        end
      end
    end
    assert out.index(/ok/), 'Failed vector test'
  end

  def test_arcball
    out, _err_ = capture_io do
    open('|../bin/rp5 run arcball.rb', 'r') do |io|
      while l = io.gets
        puts(l.chop)
        end
      end
    end
    assert_match(/ok/, out, 'Failed arcball sketch')
  end
end


