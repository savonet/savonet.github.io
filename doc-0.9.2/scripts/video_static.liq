# Log to stdout
set("log.file",false)
set("log.stdout",true)
# Don't follow wall-clock time, run at maximum speed!
set("root.sync",false)
# Enable video
set("frame.video.channels",1)

# The video source using a static image
s = video.image(width=240,height=240,x=40,"/tmp/bla.ppm")
# The audio file
audio = single("/tmp/bla.mp3")

# The special metadata function, that also triggers shutdown.
def end_meta(_) =
 shutdown()
 [("title","garbage")]
end
# Our special blank source
bl = map_metadata(end_meta,blank())

# And the final source: the sequence song and blank added
# with the video of the static image..
final = add([sequence([audio,bl]),s])

# Output to a theora file
output.file.theora(reopen_on_metadata=true,
                   "/tmp/$(title).ogv",final)
