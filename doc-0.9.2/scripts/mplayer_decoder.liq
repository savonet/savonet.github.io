# Enable mplayer decoder (needs mplayer binary in path)
# @category Liquidsoap
def enable_mplayer()=
  def mplayer_p(file)=
    "mplayer -really-quiet \
        -ao pcm:file=/dev/stdout \
        -vc null -vo null #{quote(file)} \
        2>/dev/null"
  end
  if test_process("which mplayer") then
    add_decoder("MPLAYER",mplayer_p)
  else
    log(label="utils.liq",level=2,
          "couldn't enable mplayer \
             decoder: no binary found")
  end
end
