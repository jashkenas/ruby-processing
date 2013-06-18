#
# Reverse playback example.
#
# The Movie.speed method allows to change the playback speed. 
# Use negative values for backwards playback. Note that not all 
# video formats support backwards playback. This depends on the 
# underlying gstreamer plugins used by gsvideo. For example, the 
# theora codec does support backward playback, but not so the H264 
# codec, at least in its current version.
# 
#
load_library :video
include_package 'processing.video'

attr_reader :mov, :speed_set, :once

def setup
  size(640, 360)
  background(0)
  @speed_set = false
  @once = true
  @mov = Movie.new(self, "transit.mkv")
  mov.play
end

def draw  
  begin   # avoids reflection shit
    mov.read  
    if (speed_set == true)
      @speed_set = false
    end
  end unless !mov.available?
  if (speed_set == false && once == true)
    # Setting the speed should be done only once,
    # this is the reason for the if statement.
    @speed_set = true
    @once = false
    mov.jump(mov.duration)
    # -1 means backward playback at normal speed.
    mov.speed(-1.0)
    # Setting to play again, since the movie stop
    # playback once it reached the end.
    mov.play
  end
  image(mov, 0, 0, width, height)
end   

