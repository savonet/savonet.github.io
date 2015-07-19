# Output to icecast using the lame command line encoder.
# @category Source / Output
# @param ~id Output's ID
# @param ~start Start output threads on operator initialization.
# @param ~restart Restart output after a failure. By default, liquidsoap will stop if the output failed.
# @param ~restart_delay Delay, in seconds, before attempting new connection, if restart is enabled.
# @param ~restart_on_crash Restart external process on crash. If false, liquidsoap will stop.
# @param ~restart_on_new_track Restart encoder upon new track.
# @param ~restart_encoder_delay Restart the encoder after this delay, in seconds.
# @param ~user User for shout source connection. Useful only in special cases, like with per-mountpoint users.
# @param ~lame The lame binary
# @param ~bitrate Encoder bitrate
# @param ~swap Swap audio samples. Depends on local machine's endianess and lame's version. Test this parameter if you experience garbaged mp3 audio data. On intel 32 and 64 architectures, the parameter should be "true" for lame prior 3.98.
# @param ~dumpfile Dump stream to file, for debugging purpose. Disabled if empty.
# @param ~protocol Protocol of the streaming server: 'http' for Icecast, 'icy' for Shoutcast.
# @param s The source to output
def output.icecast.lame(
  ~id="output.icecast.lame",~start=true,
  ~restart=true,~restart_delay=3,
  ~host="localhost",~port=8000,
  ~user="source",~password="hackme",
  ~genre="Misc",~url="http://savonet.sf.net/",
  ~description="OCaml Radio!",~public=true,
  ~dumpfile="",~mount="Use [name]",
  ~name="Use [mount]",~protocol="http",
  ~lame="lame",~bitrate=128,~swap=false,
  ~restart_on_crash=false,~restart_on_new_track=false,
  ~restart_encoder_delay=3600,~headers=[],s)
  samplerate = get(default=44100,"frame.samplerate")
  samplerate = float_of_int(samplerate) / 1000.
  channels = get(default=2,"frame.channels")
  swap = if swap then "-x" else "" end
  mode = 
    if channels == 2 then
      "j" # Encoding in joint stereo..
    else
      "m"
    end
  # Metadata update is set by ICY with icecast
  def lame_p(m)
    "#{lame} -b #{bitrate} -r --bitwidth 16 -s #{samplerate} \
       --signed -m #{mode} --nores #{swap} -t - -"
  end
  output.icecast.external(id=id,
    process=lame_p,bitrate=bitrate,start=start,
    restart=restart,restart_delay=restart_delay,
    host=host,port=port,user=user,password=password,
    genre=genre,url=url,description=description,
    public=public,dumpfile=dumpfile,restart_encoder_delay=restart_encoder_delay,
    name=name,mount=mount,protocol=protocol,
    header=false,restart_on_crash=restart_on_crash,
    restart_on_new_track=restart_on_new_track,headers=headers,
    s)
end
