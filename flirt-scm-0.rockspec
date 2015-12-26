package = "flirt"
version = "scm-0"
source = {
   url = "/home/kyle/src/love-libs/flirt"
}
description = {
   license = "MIT"
}
dependencies = {
   "lua",
   "loadconf ~> 0.1"
}
build = {
   type = "builtin",
   modules = {
      ["flirt"] = "flirt.lua"
   },
   install = {
      bin = {"bin/flirt"}
   }
}

