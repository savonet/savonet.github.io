# Output the stream using aplay.
# Using this turns "root.sync" to false
# since aplay will do the synchronisation
# @category Source / Output
# @param ~id Output's ID
# @param ~device Alsa pcm device name
# @param ~restart_on_crash Restart external process on crash. If false, liquidsoap will stop.
# @param s Source to play
def output.aplay(~id="output.aplay",
                 ~device="default",
                 ~restart_on_crash=false,
                 s)
  def aplay_p(m) = 
    "aplay -D #{device}"
  end
  log(label=id,level=3,"Setting root.sync \
                         to false")
  set("root.sync",false)
  output.pipe.external(
    id=id,
    restart_on_crash=restart_on_crash,
    restart_on_new_track=false,
    process=aplay_p,s)
end
