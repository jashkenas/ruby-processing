# Ruby-Processing
[![Gem Version](https://badge.fury.io/rb/ruby-processing.svg)](http://badge.fury.io/rb/ruby-processing)

Is a ruby wrapper around the [Processing][] code art framework, built using [JRuby][].

[Processing][] provides a tidy API, with a bunch of handy methods you can call 
  from Ruby-Processing. Here's a smattering:
  
  alpha, arc, background, blend, blue, ellipse, frame_rate, hue, lerp, 
  load_image, load_pixels, mouse_pressed, noise, rect, saturation, shape, 
  smooth, text_align, translate, triangle...
  

## Installation
MacOSX users please try out this new  [method](https://github.com/jashkenas/ruby-processing/wiki/Installing-ruby-processing-on-the-mac)

Ideally you should install [jruby](http://jruby.org/download), at the very least you will have at least ruby-1.9.3 installed.  You should [download][] and install vanilla [processing-2.2.1](https://processing.org/download/) prior to installing this version of ruby-processing. You must also set the `PROCESSING_ROOT` in the .rp5rc yaml configuration file, the easiest way to do this is by running the [SetProcessingRoot.pde](https://gist.github.com/monkstone/7438749) sketch in the processing ide. 

Then install ruby-processing (from rubygems-org) in the usual way

`gem install ruby-processing` some systems eg Ubuntu may require `sudo` access

To install jruby-complete use our built in tool (relies on `wget` to download [jruby-complete-1.7.13](http://jruby.org/download))

since ruby-processing-2.5.0 `rp5 setup install` (was `install_jruby_complete`)

If you haven't got `wget` just download jruby-complete-1.7.13 (for ruby-processing-2.5.0)to the vendors folder (then run above tool)

The vendored jruby-complete is only required for application export, and running certain sketches (eg shader sketches see wiki).


### How to build latest version 2.6.0
See [wiki](https://github.com/jashkenas/ruby-processing/wiki/How-to-build-latest-version)

For current release (version 2.5.1) checkout the "stable" branch and follow the same instructions

## Documentation

See [Wiki][]

See also [FAQs][], [Contributing][] and [Samples][]

# Usage Example

```bash
rp5 run my_sketch.rb 
```

or if not using system jruby (and not `JRUBY: 'false'` in `~/.rp5rc`)

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

or a simple 3D sketch ``cube.rb`` features ArcBall from vecmath library

```ruby
load_library :vecmath

############################
# Use mouse drag to rotate
# the arcball. Use mousewheel
# to zoom. Hold down x, y, z
# to constrain rotation axis.
############################

def setup
  size(600, 600, P3D)
  smooth(8)
  ArcBall.init(self, 300, 300)
  fill 180
end

def draw
  background(50)
  box(300, 300, 300)
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

## Deprecated Methods

From version 2.5.1 some processing methods are deprecated in favor of ruby alternatives
for details see wiki [notice][]

[License][]

[license]:LICENSE.md
[contributing]:CONTRIBUTING.md
[jruby]:http://www.jruby.org/
[processing]: http://www.processing.org/
[download]:https://processing.org/download/
[samples]:https://github.com/jashkenas/ruby-processing/tree/master/samples/
[wiki]:http://github.com/jashkenas/ruby-processing/wikis/
[notice]:http://github.com/jashkenas/ruby-processing/wikis/Deprecation-of-methods
[FAQs]:http://github.com/jashkenas/ruby-processing/wikis/FAQs/
[release]:https://github.com/jashkenas/ruby-processing/releases/


