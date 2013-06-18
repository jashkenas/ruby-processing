# This sketch demonstrates how to create synthesized sound with Minim using an <code>AudioOutput</code> and the
# default instrument built into an <code>AudioOutput</code>. By using the <code>play_note</code> method you can 
# schedule notes to played at some point in the future, essentially allowing to you create musical scores with 
# code. Because they are constructed with code, they can be either deterministic or different every time. This
# sketch creates a deterministic score, meaning it is the same every time you run the sketch. It also demonstrates 
# a couple different versions of the <code>play_note</code> method.
# <p>
# For more complex examples of using <code>play_note</code> check out algorithmicCompExample and compositionExample
# in the Synthesis folder.
#
load_library 'minim'
include_package 'ddf.minim'
include_package 'ddf.minim.ugens'

attr_reader :minim, :out

def setup
  size(512, 200, P3D)  
  @minim = Minim.new(self)
  
  # use the getLineOut method of the Minim object to get an AudioOutput object
  @out = minim.get_line_out()
  
  # given start time, duration, and frequency
  out.play_note( 0.0, 0.9, 97.99 )
  out.play_note( 1.0, 0.9, 123.47 )
  
  # given start time, duration, and note name  
  out.play_note( 2.0, 2.9, "C3" )
  out.play_note( 3.0, 1.9, "E3" )
  out.play_note( 4.0, 0.9, "G3" )
    
  # given start time and note name or frequency
  # (duration defaults to 1.0)
  out.play_note( 5.0, "" )
  out.play_note( 6.0, 329.63)
  out.play_note( 7.0, "G4" )
  
  # the note offset is simply added into the start time of 
  # every subsequenct call to play_note. It's expressed in beats, 
  # but since the default tempo of an AudioOuput is 60 beats per minute,
  # this particular call translates to 8.1 seconds, as you might expect.
  out.setNoteOffset( 8.1 )
  
  # because only given a note name or frequency
  # starttime defaults to 0.0 and duration defaults to 1.0
  out.play_note( "G5" )
  out.play_note( 987.77 )
end

def draw
  background(0)
  stroke(255)  
  # draw the waveforms
  (0 ... out.buffer_size - 1).step do |i|
    line( i, 50 + out.left.get(i)*50, i+1, 50 + out.left.get(i+1)*50 )
    line( i, 150 + out.right.get(i)*50, i+1, 150 + out.right.get(i+1)*50 )
  end
end
