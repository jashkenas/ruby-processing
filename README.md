# Ruby-Processing

Is a ruby wrapper around the [Processing][] code art framework, built using [JRuby][].

[Processing][] provides a tidy API, with a bunch of handy methods you can call 
  from Ruby-Processing. Here's a smattering:
  
  alpha, arc, background, blend, blue, ellipse, frame_rate, hue, lerp, 
  load_image, load_pixels, mouse_pressed, noise, rect, saturation, shape, 
  smooth, text_align, translate, triangle...

## Installation
Either clone this repo to your local Mac/Linux/Windows system
```bash
git clone https://github.com/jashkenas/ruby-processing.git
```
Or download a [Release][] snapshot and unzip that followed by
```bash
cd ruby-processing
rake # build and test gem
gem install ruby-processing-2.1.0.gem # to install gem
```
Or if using jruby
```bash
jruby -S gem ruby-processing-2.1.0.gem # to install gem
```
Previously we were able to provide a simple install from rubygems, unfortunately this is no longer possible, owing to a policy change at rubygems.org (this gem is way too big), I don't think we could use bundler but I'm prepared to be proved wrong. A legacy version ruby-processing-1.0.11 is still available, but no-one is prepared to maintain it, and it would also fall foul of the policy change at rubygems.org

## Documentation

See [Wiki][]

See also [Contributing][] and [Samples][]

# Usage Example

```bash
rp5 run my_sketch.rb
```
where a simple my_sketch.rb could look like this

```ruby
def setup
  size 400, 400  
  fill 255
end

def draw
  background 0
  ellipse mouse_x, mouse_y, 100, 100
end
```

or a simple 3D sketch cube.rb

```ruby
def setup
  size 640, 360, P3D 
  @xmag = 0
  @ymag = 0
  @new_xmag = 0
  @new_ymag = 0 
  fill 200, 50, 50
end

def draw    
  background 100    
  push_matrix    
  translate width/2, height/2, -30    
  @new_xmag = mouse_x.to_f / width * TWO_PI
  @new_ymag = mouse_y.to_f / height * TWO_PI    
  diff = @xmag - @new_xmag
  @xmag -= diff / 4 if diff.abs > 0.01    
  diff = @ymag - @new_ymag
  @ymag -= diff / 4 if diff.abs > 0.01    
  rotate_x(-@ymag) 
  rotate_y(-@xmag)    
  box 150, 150, 150        
  pop_matrix        
end

```

## Supported Ruby Version

This library has been tested with the following ruby implementations

* Ruby 1.9.3
* Ruby 2.0.0
* [JRuby][]

[License][]

[license]: LICENSE.md
[contributing]: CONTRIBUTING.md
[jruby]: http://www.jruby.org/
[processing]: http://www.processing.org/
[samples]: https://github.com/jashkenas/ruby-processing/tree/master/samples/
[wiki]: https://github.org/jashkenas/wiki/
[release]: https://github.com/jashkenas/ruby-processing/releases/
## What's new

Well for a start the repo has been drastically reduced in size, this was done by deleting unused binaries in the repos history. Anyone who has previously forked this repo (before 27 July 2013), is advised to delete their fork and fork anew.

New capabilities since processing-2.0 include ability to use OPENGL VBO (PShape) and GLSL shaders (PShader), to keep abreast of latest shader developments for processing check out the [codeanticode blog](http://codeanticode.wordpress.com/2013/06/04/processing-2-0-is-out-processing-2-0-is-in/). Some worked examples using new feature are included in the samples. The update to the latest jruby is also significant as the default is to run with ruby-1.9 support, and there have been many performance improvements. To use the invoke-dynamic java support for dynamic language, use java-7+ (NB: on the Mac need Intel-based Mac running Mac OS X version 10.7.3 and above to install java 7 otherwise use java 6). Many more worked examples are included in the [Samples][].



