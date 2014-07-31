Building the custom nn Library
==============================
This is an example of a java library that you can build yourself with the included Rakefile.
You need a jdk, a system version of jruby and the ruby-compiler gem to build the nn library 
(see ext dir).
Compiling and building the jar is dead easy just issue the following command in a console.

`jruby -S rake compile`

you may also need to set JAVA_HOME to point to your jdk eg

`export JAVA_HOME=/opt/jdk1.7.0_65` for linux users 

You can even run the sketch using `rake`, with the `:run` task `rake run` and tidy up when your are done `rake clean`

This example was taken from [The Nature of Code](https://github.com/shiffman/The-Nature-of-Code) by Dan Shiffman, except the example has been rubified (and even the java code was doctored to be more up to date, and to prefer double to float).
