package = "flirt"
version = "scm-0"
source = {
   url = "git://github.com/Alloyed/flirt"
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

