# First parse key,value list:
hint = [("key","value")]
data = of_json(default=hint,payload)
print(data["uri"]) # "https://..."

# Then key -> (key,value) list
hint = [("list",[("key","value")])]
data = of_json(default=hint,payload)
m    = data["metadata"]
print(m["title"]) # "foo"
