package = "flirt"
version = "0.1.0-1"
source = {
   url = "git://github.com/Alloyed/flirt",
   tag = "v0.1.0"
}
description = {
   license = "MIT"
}
dependencies = {
   "lua", "loadconf ~> 0.1"
}
build = {
   type = "builtin",
   modules = {
      flirt = "flirt.lua"
   },
   install = {
      bin = {
         "bin/flirt"
      }
   }
}
