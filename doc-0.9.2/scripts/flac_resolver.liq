if test_process("which metaflac") then
  def flac_meta(~format,file)
    if format != "FLAC" then
      []
    else
      ret = get_process_lines("metaflac \
        --export-tags-to=- \
        #{quote(file)} 2>/dev/null")
      ret = list.map(
               string.split(separator="="),ret)
      # Could be made better..
      def f(l',l)=
        if list.length(l) >= 2 then
          list.append([(list.hd(l),
                        list.nth(l,1))],l')
        else
          if list.length(l) >= 1 then
            list.append([(list.hd(l),"")],l')
          else
            l'
          end
        end
      end
      list.fold(f,[],ret)
    end
  end
  add_metadata_resolver("FLAC",flac_meta)
else
  log(level=3,"metaflac binary not found: \
        flac metadata resolver disabled.")
end
