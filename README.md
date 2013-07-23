Ruby Processing
==========


This is the official source code for the development version of ruby-processing, which is currently based on [processing-2.0.1](https://processing.org/download/), and [jruby-1.7.4](http://www.jruby.org/).  

It is entirely possible that any issues you may experience with this version of ruby-processing may come from either source, both of which are still in active development otherwise you can probably blame @monkstone.  It is better that any "bugs" are reported [here](https://github.com/monkstone/ruby-processing/issues?direction=desc&sort=created&state=open) first unless you are absolutely sure that [processing-2.0.1](https://github.com/processing/processing/issues) or [jruby](https://github.com/jruby/jruby/issues?state=open) are to blame.  This build has been tested on both linux and MacOSX, I would be keen to hear from any MacOSX and Windows users and how it works for them. The build downloads processing-2.0.1 (the Mac version as it smallest that provides the required jars) It is on your conscience whether you make a donation to [processing.org](http://processing.org/foundation/). Also included is jruby-complete (version 1.7.4), which seems to be required to run shader sketches, further its inclusion also means you do need to have jruby installed to run ruby-processing.

OS requirements to run processing
------------------------------------

[Requirements according to processing developers](http://wiki.processing.org/w/Supported_Platforms), personally I've found ruby-processing runs just fine with both Oracle java 7 and OpenJDK 7, so I take their recommendations with a pinch of salt. In fact to get InvokeDynamic improvements you should do just that...

What's new
----------------

New capabilities since processing-2.0 include ability to use OPENGL VBO (PShape) and GLSL shaders (PShader), to keep abreast of latest developments check out the [codeanticode blog](http://codeanticode.wordpress.com/2013/06/04/processing-2-0-is-out-processing-2-0-is-in/). Some worked examples using new feature are included in the samples. The update to the latest jruby is also significant as the default is to run with ruby-1.9 support, and there have been many performance improvements. To use the invoke-dynamic java support for dynamic language, use java-7+ (NB: on the Mac need Intel-based Mac running Mac OS X version 10.7.3 and above to install java 7 otherwise use java 6). Many more worked examples are included.

The original version
--------------------------- 

NB: Version 1.0.11 is the last version to be available as a rubygem (processing-1.5.1, jruby-1.6.5)
```bash
gem install ruby-processing
```
The current version 2.1.0 is available as autobuild archive download [here](https://github.com/monkstone/ruby-processing/releases/tag/2.1.0), or you really might as well clone the development version. NB: the gem is too big to be hosted at rubygems.org, so it will never be located there.

Get Involved
------------------
[Fork it](https://help.github.com/articles/fork-a-repo) / [fixit](https://github.com/jruby/jruby/issues?state=open) / improve it / [add samples](https://github.com/monkstone/ruby-processing/tree/master/samples) / promote it

