package = "flirt"
version = "0.3.0-1"
source = {
   url = "git://github.com/Alloyed/flirt",
   tag = "v0.3.0"
}
description = {
   summary = "A wrapper for running love games",
   detailed = [[
Flirt is a small script that matches up LÖVE games with the appropriate Love
binary, so that each game is run using the version of LÖVE it was developed
for.]],
   homepage = "https://github.com/Alloyed/flirt",
   license = "MIT"
}
dependencies = {
   "lua ~> 5.1",
   "loadconf >= 0.3.3, < 0.4"
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

