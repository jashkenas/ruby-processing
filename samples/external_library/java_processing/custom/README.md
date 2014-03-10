Building the custom nn Library
==============================
This is an example of a java library that you can build yourself with the included Rakefile.
Ideally you will both have ant and jruby installed (you should also have a jdk-7+ installed).

If you have done all of that compiling and building jar is dead easy just issue the following command in a console.

`jruby -S rake`

you may also need to set JAVA_HOME to point to your jdk eg

`export JAVA_HOME=/opt/jdk1.7.0_51` for linux users 


This example was taken from [The Nature of Code](https://github.com/shiffman/The-Nature-of-Code) by Dan Shiffman, except the example has been rubified (and even the java code was doctored to be more up to date, and to prefer double to float).
