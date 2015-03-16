# Ruby-Processing
[![Gem Version](https://badge.fury.io/rb/ruby-processing.svg)](http://badge.fury.io/rb/ruby-processing)

Is a ruby wrapper around the [Processing][] code art framework, built using [JRuby][].

[Processing][] provides a tidy API, with a bunch of handy methods you can call 
  from Ruby-Processing. Here's a smattering:
  
  `alpha`, `arc`, `background`, `blend`, `blue`, `ellipse`, `frame_rate`, `hue`, `lerp`,  `load_image`, `load_pixels`, `mouse_pressed`, `noise`, `rect`, `saturation`, `shape`, `smooth`, `text_align`, `translate`, `triangle`, `vertex`...
  

## Installation
We assume you have some version of ruby installed if not, there is a [guide to installing][] ruby on various platforms including windows. Or here is an [alternative install][] guide.

MacOSX users please try out this new  [method](https://github.com/jashkenas/ruby-processing/wiki/Installing-ruby-processing-on-the-mac) or see this [japanese][] guide.

Ideally you should install [jruby](http://jruby.org/download), at the very least you will have at least ruby-1.9.3 installed.  You should [download][] and install vanilla [processing-2.2.1](https://processing.org/download/) prior to installing this version of ruby-processing. You must also set the `PROCESSING_ROOT` in the .rp5rc yaml configuration file, the easiest way to do this is by running the [SetProcessingRoot.pde](https://gist.github.com/monkstone/7438749) sketch in the processing ide. 

Then install ruby-processing (from rubygems-org) in the usual way

`gem install ruby-processing` some systems eg Ubuntu may require `sudo` access

To install jruby-complete use our built in tool (relies on `wget` to download [jruby-complete-1.7.18](http://jruby.org/download))

since ruby-processing-2.5.0 `rp5 setup install` (was `install_jruby_complete`)

If you haven't got `wget` just download jruby-complete-1.7.19 (for ruby-processing-2.6.7)to the vendors folder (then run above tool)

The vendored jruby-complete is only required for application export, and running certain sketches (eg shader sketches see [wiki][]).


### How to build latest development version 2.6.8
See [wiki](https://github.com/jashkenas/ruby-processing/wiki/How-to-build-latest-version)

For previous release (version 2.6.7) checkout the "stable" branch and follow the same instructions

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
See [samples][] for many more examples
___

### Supported java version

NB: you can't use jdk/jre installed by processing
* Open jdk8 (latest version preferred, is the default linux install)
* jdk7 from Oracle (latest version preferred, or required by Mac)
* jdk8 from Oracle (latest version preferred, or required by Mac)

### Supported ruby version

This gem has been tested with the following ruby implementations

* Ruby 1.9.3
* Ruby 2.0.0
* Ruby 2.1.2
* Ruby 2.2.1
* [JRuby][] preferred (required to use rubygems in sketches)

NB: current support for ruby-2.0 syntax is limited (and experimental see jruby documentation).
However if you use JRuby-9.0.0.0.pre1 you will find ruby-2.2 syntax is now supported (try jruby-9000-pre branch). Future development of ruby-processing will target ruby-2.2 (with probable backward compatibitility with MRI ruby-2.1) any further backward compability will be accidental and unsupported (owing to limited resources).

### Supported processing version

* processing-2.2.1 (recommended)
* seems also work with processing-3.0a5 (might be worth upgrading to, a more recent jogl etc....)

### Replacements for processing convenience methods in ruby

Many of processing (convenience) methods make little sense in ruby (and in recent versions of ruby-processing many are no-longer implemented). See ruby alternatives for [details][].

[License][]

[license]:LICENSE.md
[contributing]:CONTRIBUTING.md
[jruby]:http://www.jruby.org/
[processing]: http://www.processing.org/
[download]:https://processing.org/download/
[samples]:https://github.com/ruby-processing/Example-Sketches
[wiki]:http://github.com/jashkenas/ruby-processing/wikis/
[details]:http://github.com/jashkenas/ruby-processing/wikis/Deprecation-of-methods
[FAQs]:http://github.com/jashkenas/ruby-processing/wikis/FAQs/
[release]:https://github.com/jashkenas/ruby-processing/releases/
[guide to installing]:https://www.ruby-lang.org/en/installation/
[alternative install]:http://tutorials.jumpstartlab.com/topics/environment/environment.html
[fix]:https://github.com/jruby/jruby/issues/1917
[japanese]:http://qiita.com/yohm13/items/f3f82f423b507cec1dcc

