rbest/vim
:syntax onsketches/sketches/
b
========
sketches/
OK strictly thesketches/ould dsketches/est objects, rather than the indirect tests on io here. These test make use of minitest capture_io (this seems to require real files rather than temp files?). Also there seems to be some problem with how the built in version minitest run so I've specified gem "minitest". The graphics test is designed to fail if your graphics setup does not supports opengl 3+, this may not be fatal, but as message states is probably suboptimal.
sketches/
[gist]:https://gist.githusketches/kstone/6145906
