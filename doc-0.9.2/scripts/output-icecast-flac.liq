# Output to icecast using the flac command line encoder.
# @category Source / Output
# @param ~id Output's ID
# @param ~start Start output threads on operator initialization.
# @param ~restart Restart output after a failure. By default, liquidsoap will stop if the output failed.
# @param ~restart_delay Delay, in seconds, before attempting new connection, if restart is enabled.
# @param ~restart_on_crash Restart external process on crash. If false, liquidsoap will stop.
# @param ~restart_on_new_track Restart encoder upon new track. If false, the resulting stream will have a single track.
# @param ~restart_encoder_delay Restart the encoder after this delay, in seconds.
# @param ~user User for shout source connection. Useful only in special cases, like with per-mountpoint users.
# @param ~flac The flac binary
# @param ~quality Encoder quality (0..8)
# @param ~dumpfile Dump stream to file, for debugging purpose. Disabled if empty.
# @param ~protocol Protocol of the streaming server: 'http' for Icecast, 'icy' for Shoutcast.
# @param s The source to output
def output.icecast.flac(
  ~id="output.icecast.flac",~start=true,
  ~restart=true,~restart_delay=3,
  ~host="localhost",~port=8000,
  ~user="source",~password="hackme",
  ~genre="Misc",~url="http://savonet.sf.net/",
  ~description="OCaml Radio!",~public=true,
  ~dumpfile="",~mount="Use [name]",
  ~name="Use [mount]",~protocol="http",
  ~flac="flac",~quality=6,
  ~restart_on_crash=false,
  ~restart_on_new_track=true,
  ~restart_encoder_delay=(-1),s)
  # We will use raw format, to 
  # bypass input length value in WAV
  # header (input length is not known)
  channels = get(default=2,"frame.channels")
  samplerate = get(default=44100,"frame.samplerate")
  def flac_p(m)=
    def option(x) = 
      "-T #{quote(fst(x))}=#{quote(snd(x))}"
    end
    m = list.map(option,m)
    m = string.concat(separator=" ",m) 
    "#{flac} --force-raw-format --endian=little --channels=#{channels} \
      --bps=16 --sample-rate=#{samplerate} --sign=signed #{m} \
      -#{quality} --ogg -c -"
  end
  output.icecast.external(id=id,
    process=flac_p,bitrate=(-1),start=start,
    restart=restart,restart_delay=restart_delay,
    host=host,port=port,user=user,password=password,
    genre=genre,url=url,description=description,
    public=public,dumpfile=dumpfile,
    name=name,mount=mount,protocol=protocol,
    restart_on_new_track=restart_on_new_track,
    format="ogg",header=false,icy_metadata=false,
    restart_on_crash=restart_on_crash,
    restart_encoder_delay=restart_encoder_delay,
    s)
end
