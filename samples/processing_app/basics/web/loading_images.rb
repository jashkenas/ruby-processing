# Loading Images. 
# 
# Loading ruby processing "blue ruby". 
# Processing applications can only load images from the network
# while running in the Processing environment. This example will 
# not run in a web browser and will only work when the computer
# is connected to the Internet. 


def setup  	
  size 200, 200  	
  background 255  	
	img1 = load_image "http://s3.amazonaws.com/jashkenas/images/ruby.jpg"	
	image img1, 0, 45
end
