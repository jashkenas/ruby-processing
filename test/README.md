Minitest
========

OK strictly the tests should directly test objects, rather than the indirect tests on io here. I've written alternative in this [gist][], that makes use of minitest capture_io, seems to require real files rather than temp files? There seems to be some problem with how the built in minitest run so I've specified gem "minitest" (if you need to you can probably comment out that line, rather than install an external minitest gem (however you will probably get some warning which you can probably ignore, someone is trying to be too clever I suspect). 

[gist]:https://gist.github.com/monkstone/6145906
