#!/usr/bin/liquidsoap

# === Settings ===

set("log.file.path","/var/log/liquidsoap/pi.log")
set("init.daemon",true)
set("init.daemon.pidfile.path","/var/run/liquidsoap/pi.pid")
set("server.telnet",true)
set("harbor.bind_addr","0.0.0.0")
set("harbor.port",8000)
set("harbor.password","xxxxxx")
set("log.level",4)
set("scheduler.event_queues",4)
set("scheduler.log",false)

scripts = "/path/to/scripts/"

pass = "xxxxxx"
ice_host = "host"

descr = "Radio Piston"
url = "http://radiopi.org"

# === Live relays ===

def live_start() =
  log("got live source, starting relays..")
  ignore(execute("stream_relay.start"))
  ignore(execute("archives.start"))
end

def live_stop() =
  log("live source has gone, stoping relays..")
  ignore(execute("stream_relay.stop"))
  ignore(execute("archives.stop"))
end

# Live source through harbor
live = input.harbor(id="live",on_connect=live_start,on_disconnect=live_stop,"live.ogg")
live_safe = mksafe(live)

# Live relay to secondary encoder
output.icecast.vorbis(id="stream_relay",start=false,restart=true,host="1.2.3.4",port=8005,password="xxxx",mount="live.ogg",live_safe)

# File source for archiving
title = '$(if $(title),"$(title)","Emission inconnue")$(if $(artist), " par  $(artist)") - %m-%d-%Y, %H:%M:%S'
output.file.vorbis(id="archives",start=false,reopen_on_metadata=true,"/path/to/archives/" ^ title ^ ".ogg",live_safe)

# === Main script ===

# Specialize the output functions by partial application
output.icecast     = output.icecast.mp3(restart=true,description=descr, url=url)
out = output.icecast(host=ice_host,port=8080,password=pass)

# A file for playing during failures
interlude =
  single("/path/to/failure.mp3")

def fallback.transition(previous,next)
  add([fade.in(next),fade.final(duration=5.,previous)])
end

# === Channels ===

# Lastfm submission
def lastfm (m) =
# Only submit songs of type "chansons" (got type using annotate..)
  if (m["type"] == "chansons") then
    canal = m["canal"]
    user = "radiopi-" ^ canal
    lastfm.submit(user=user,password="xxxxxx",m)
  end
end

# To create a channel from a basic source, add:
# - a new-track notification for radiopilote
# - metadata rewriting
# - the live shows
# - the failsafe 'interlude' source to channels
# - blank detection
def mklive(source)
  # Add lastfm submission
  source = on_metadata(lastfm,source)

  # Feedback the system
  source = on_metadata(fun (meta) ->
                    system(scripts ^ "radiopilote-feedback "
                           ^quote(meta["canal"])^" "
                           ^quote(meta["file_id"])), source)

  # Rewrite metadata to add channel name and mode..
  # Got data from annotate..
  rewrite_metadata(
   [("artist",'$(if $(display_artist),"$(display_artist)","$(artist)")'),
    ("comment",""),
    ("title", '$(if $(display_title),"$(display_title)","$(title)")'),
    ("album", '$(if $(display_album),"$(display_album)","$(album)")')],

   # Default fallback
   fallback(track_sensitive=false,[
     # Strip blank to avoid live streaming only blank..
     strip_blank(live, length=10., threshold=-50.),
        source, interlude ]) )
end

# === Basic sources ===

# Create a radiopilote-driven source
def channel_radiopilote(~skip=true,name)
  log("Creating canal #{name}")

  # Request function
  def request () =
    log("Request for #{name}")
    request.create(audio=true,
        get_process_output(scripts ^ "radiopilote-getnext " ^ quote(name)))
  end

  # Basic source
  source =   request.dynamic(
          id="dyn_"^name,request)

  # Add smart crossfading
  source = smart_crossfade(source)

  # Only skip some channels
  if skip then
    skip_blank(source, length=10., threshold=-40.)
  else
    source
  end
end

# Channels encoded here
reggae = channel_radiopilote("reggae")
jazz = channel_radiopilote("jazz")
discoqueen = channel_radiopilote("discoqueen")
# Avoid skiping blank with classic music !!
classique = channel_radiopilote(skip=false,"classique")
That70Sound = channel_radiopilote("That70Sound")

# Create a channel using mklive(), encode and output it to icecast.
def mkoutput(mount,source,name,genre)
  out(mount=mount,name=name,genre=genre,
     mklive(source))
end

# === Outputs ===

# These channels are encoded on this machine
reggae  = mkoutput("reggae", reggae, "RadioPi - Canal Reggae","reggae")
jazz    = mkoutput("jazz", jazz, "RadioPi - Canal Jazz","jazz")
discoqueen  = mkoutput("discoqueen", discoqueen, "RadioPi - Canal DiscoQueen","discoqueen")
classique = mkoutput("classique", classique, "RadioPi - Canal Classique","classique")
That70Sound = mkoutput("That70Sound", That70Sound,
                       "RadioPi - Canal That70Sound","That70Sound")

# Channels from the other encoder:
def get_channel(mount)
 input.http(autostart=true,id="input_"^mount,"http://host:8080/"^mount)
end
metal = get_channel("metal")
electro = get_channel("electro")
hiphop = get_channel("hiphop")


# Finally the web channel, and its mp3 version
web =
  out(mount="radioPi",name="RadioPi - www.radiopi.org",
      fallback([ switch(track_sensitive=false,
                        [ ( { 6h-12h }, reggae  ),
                          ( { 12h-14h }, discoqueen ),
                          ( { 14h-16h }, electro ),
                          ( { 16h-19h }, reggae ),
                          ( { 19h-20h }, That70Sound ),
                          ( { 20h-22h }, metal ),
                          ( { 22h-0h }, reggae ),
                          ( {  0h-6h  }, jazz  ),
                         ]),
                 interlude ]))

