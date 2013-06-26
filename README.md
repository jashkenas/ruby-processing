Ruby Processing
==========


This is the official source code for the development version of ruby-processing, which is currently based on [processing-2.0.1](https://processing.org/download/), and [jruby-1.7.4](http://www.jruby.org/).  

It is entirely possible that any issues you may experience with this version of ruby-processing may come from either source, both of which are still in active development otherwise you can probably blame @monkstone.  It is better that any "bugs" are reported [here](https://github.com/jashkenas/ruby-processing/issues?direction=desc&sort=created&state=open) first unless you are absolutely sure that [processing-2.0.1](https://github.com/processing/processing/issues) or [jruby](https://github.com/jruby/jruby/issues?state=open) are to blame.  This build has been tested on both linux and MacOSX, I would be keen to hear from any MacOSX and Windows users and how it works for them. The build downloads processing-2.0.1 (the Mac version as it smallest that provides the required jars) It is on your conscience whether you make a donation to [processing.org](http://processing.org/foundation/). Also included is jruby-complete (version 1.7.4), which seems to be required to run shader sketches, further its inclusion also means you do need to have jruby installed to run ruby-processing.

What's new
----------------

New capabilities since processing-2.0 include ability to use OPENGL VBO (PShape) and GLSL shaderd (PShader), worked examples are included the samples. The update to the latest jruby is also significant as the default is to run with ruby-1.9 support, and there have been many performance improvements. To use the invoke-dynamic java support for dynamic language, use java-7+ (NB: on the Mac need Intel-based Mac running Mac OS X version 10.7.3 and above to install java 7 otherwise use java 6). Many more worked examples are included.

The original version
--------------------------- 

NB: Version 1.0.11 is still available as a rubygem (processing-1.5.1, jruby-1.6.7)
<pre><code>
gem install ruby-processing
</pre></code>
See text README (however no-one has shown any interest in maintaining it, so after some testing, and possibly after jruby-1.7.5 release it will be replaced!!!).

Get Involved
------------------
[Fork it](https://help.github.com/articles/fork-a-repo) / [fixit](https://github.com/jruby/jruby/issues?state=open) / improve it / [add samples](https://github.com/jashkenas/ruby-processing/tree/master/samples) / promote it

