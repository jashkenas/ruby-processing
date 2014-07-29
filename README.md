# Ruby-Processing
[![Gem Version](https://badge.fury.io/rb/ruby-processing.svg)](http://badge.fury.io/rb/ruby-processing)

Is a ruby wrapper around the [Processing][] code art framework, built using [JRuby][].

[Processing][] provides a tidy API, with a bunch of handy methods you can call 
  from Ruby-Processing. Here's a smattering:
  
  alpha, arc, background, blend, blue, ellipse, frame_rate, hue, lerp, 
  load_image, load_pixels, mouse_pressed, noise, rect, saturation, shape, 
  smooth, text_align, translate, triangle...
  
## How to build latest version 2.5.0
See [wiki](https://github.com/jashkenas/ruby-processing/wiki/How-to-build-latest-version)

## Installation
MacOSX users please try out this new  [method](https://github.com/jashkenas/ruby-processing/wiki/Installing-ruby-processing-on-the-mac)

Ideally you should install [jruby](http://jruby.org/download), at the very least you will have at least ruby-1.9.3 installed.  You should [download][] and install vanilla [processing-2.2.1](https://processing.org/download/) prior to installing this version of ruby-processing. You must also set the `PROCESSING_ROOT` in the .rp5rc yaml configuration file, the easiest way to do this is by running the [SetProcessingRoot.pde](https://gist.github.com/monkstone/7438749) sketch in the processing ide. 

Then install ruby-processing (from rubygems-org) in the usual way

`gem install ruby-processing` some systems eg Ubuntu may require `sudo` access

To install jruby-complete use our built in tool (relies on `wget` to download [jruby-complete-1.7.12](http://jruby.org/download))

since ruby-processing-2.5.0 `rp5 setup install` (was `install_jruby_complete`)

If you haven't got `wget` just download jruby-complete-1.7.13 (for ruby-processing-2.5.0)to the vendors folder (then run above tool)

The vendored jruby-complete is only required for application export, and running certain sketches (eg shader sketches see wiki).


## Documentation

See [Wiki][]

See also [FAQs][], [Contributing][] and [Samples][]

# Usage Example

```bash
rp5 run my_sketch.rb 
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
* Ruby 2.1.2
* [JRuby][] preferred (required to use rubygems in sketches)

NB: Support for ruby-2.0 syntax is limited (and experimental see jruby documentation)

## Supported Processing Version

* processing-2.2.1 (recommended)
* seems also work with processing-3.0a1 (but there is probably no reason to use it)

[License][]

[license]:LICENSE.md
[contributing]:CONTRIBUTING.md
[jruby]:http://www.jruby.org/
[processing]: http://www.processing.org/
[download]:https://processing.org/download/
[samples]:https://github.com/jashkenas/ruby-processing/tree/master/samples/
[wiki]:http://github.com/jashkenas/ruby-processing/wikis/
[FAQs]:http://github.com/jashkenas/ruby-processing/wikis/FAQs/
[release]:https://github.com/jashkenas/ruby-processing/releases/


