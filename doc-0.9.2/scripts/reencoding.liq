set("root.sync",false)
input = "/some/file.mp3" # any format supported by liquidsoap
output = "/tmp/output.ogg"
source = once(single(input))
output.file.vorbis(output,fallible=true,on_stop=shutdown,source)
