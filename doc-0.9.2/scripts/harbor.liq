# Serveur settings
set("harbor.bind_addr","0.0.0.0")
set("harbor.port",8080)
set("harbor.password","hackme")

# An emergency file
emergency = single("/path/to/emergency/single.ogg")

# A playlist
playlist = playlist("/path/to/playlist")

# A live source
live = input.harbor("live")

# fallback
radio = fallback(track_sensitive=false,
                 [live,playlist,emergency])

# output it
output.icecast.vorbis(radio,mount="test",host="host")
