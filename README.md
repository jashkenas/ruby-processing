# Ruby-Processing

Checkout the development branch [here]:https://github.com/monkstone/ruby-processing, pretty soon we will expect to return to hosting ruby-processing at rubygems.org `gem install ruby-processing` some volunteer testers rquired especially Mac Windows users.

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

See special instructions for Windows Users in the [Wiki][]

```bash
cd ruby-processing
rake # build and test gem (actually build and install if windows)
jruby -S gem install ruby-processing-2.3.0.gem # to install gem, may need sudo
```

Or if not using jruby
```bash
gem install ruby-processing-2.3.0.gem # to install gem, may need sudo

```

Previously we were able to provide a simple install from rubygems, unfortunately this is no longer possible, owing to a policy change at rubygems.org (this gem is way too big), I don't think we could use bundler but I'm prepared to be proved wrong. A legacy version ruby-processing-1.0.11 is still available, but no-one is prepared to maintain it, and it would also fall foul of the policy change at rubygems.org

## Documentation

See [Wiki][]

See also [FAQs][], [Contributing][] and [Samples][]

# Usage Example

```bash
jruby -S rp5 run my_sketch.rb # depending on your OS/setup you might not really need jruby -S
```

or if not using system jruby

```bash
rp5 --nojruby run my_sketch.rb
```

where a simple ``my_sketch.rb`` could look like this

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

or a simple 3D sketch ``cube.rb``

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
* [JRuby][] preferred (required to use rubygems in sketches)

[License][]

[license]:LICENSE.md
[contributing]:CONTRIBUTING.md
[jruby]:http://www.jruby.org/
[processing]: http://www.processing.org/
[samples]:https://github.com/jashkenas/ruby-processing/tree/master/samples/
[wiki]:http://github.com/jashkenas/ruby-processing/wikis/
[FAQs]:http://github.com/jashkenas/ruby-processing/wikis/FAQs/
[release]:https://github.com/jashkenas/ruby-processing/releases/

## What's new

Well for a start the repo has been drastically reduced in size, this was done by deleting unused binaries in the repos history. Anyone who has previously cloned/forked this repo ( _before 27 July 2013_ ), is advised to delete their clone/fork and clone/fork anew.  The other major change (since ruby-processing-2.1.2) is that using an external jruby is the default (jruby-complete is retained for those sketches, mainly shader that need it, and for application export), which simplifies the use of rubygems. To revert to using the vendored jruby-complete, just use use the --nojruby flag.

New capabilities since processing-2.0 include ability to use OPENGL VBO (PShape) and GLSL shaders (PShader), to keep abreast of latest shader developments for processing check out the [codeanticode blog](http://codeanticode.wordpress.com/2013/06/04/processing-2-0-is-out-processing-2-0-is-in/). Some worked examples using new feature are included in the samples. The update to the latest jruby is also significant as the default is to run with ruby-1.9 support, and there have been many performance improvements. To use the invoke-dynamic java support for dynamic language, use java-7+ (Mac users can read more about [Oracle java here](http://www.java.com/en/download/faq/java_mac.xml) ). More than 330 worked examples are included in the [Samples][], many of which are rubified version of the examples included with vanilla processing, and or the contributed libraries, additions are welcome.



