if test_process("which faad") then
  def faad_p(file)=
    "faad -o /dev/stdout #{quote(file)} \
          2>/dev/null"
  end
  add_decoder("FAAD",faad_p)
  def faad_meta(~format,file)
    if format != "FAAD" then
      []
    else
      ret = get_process_lines("faad -i \
                   #{quote(file)} 2>&1")
      def get_meta(l,s)=
        ret = string.extract(
              pattern="^(\w+):\s(.+)$",s)
        if list.length(ret) > 0 then
          list.append([(ret["1"],ret["2"])],l)
        else
          l
        end
      end
      list.fold(get_meta,[],ret)
    end
  end
  add_metadata_resolver("FAAD",faad_meta)
else
  log(level=3,"faad binary not found: \
       faad decoder disabled.")
end
