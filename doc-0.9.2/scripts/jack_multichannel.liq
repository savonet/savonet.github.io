# Set global setting.
set("frame.channels",4)

# The jack input will have the same 
# number of channels than the global 
# setting above.
s = input.jack(id="my input")

# Output this source to icecast 
# using vorbis
output.icecast.vorbis(host="my host",
  password="my password",mount="4chan.ogg",
      s)
