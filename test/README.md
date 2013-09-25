Minitest
========

OK strictly the tests should directly test objects, rather than the indirect tests on io here. These test make use of minitest capture_io (this seems to require real files rather than temp files?). Also there seems to be some problem with how the built in version minitest run so I've specified gem "minitest". The graphics test is designed to fail if your graphics setup does not supports opengl 3+, this may not be fatal, but as message states is probably suboptimal.

[gist]:https://gist.github.com/monkstone/6145906
