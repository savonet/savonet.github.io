if test_process("which flac") then
  def flac_p(file)=
    "flac -d -c #{quote(file)} 2>/dev/null"
  end
  add_decoder("FLAC",flac_p)
else
  log(level=3,"flac binary not found: \
        flac decoder disabled.")
end
