#!/usr/bin/env lua

-- make amalgamated flirt script
-- rm -f flirt_script && lua make_script.lua > flirt_script && chmod +x flirt_script

if not package.searchpath then
   function package.searchpath(name, path, sep, rep)
      sep = (sep or "."):gsub("(%p)", "%%%1")
      rep = (rep or package.config:sub(1, 1)):gsub("(%%)", "%%%1")
      local pname = name:gsub(sep, rep):gsub("(%%)", "%%%1")
      local msg = {}
      for subpath in path:gmatch("[^;]+") do
         local fpath = subpath:gsub("%?", pname)
         local f = io_open(fpath, "r")
         if f then
            f:close()
            return fpath
         end
         msg[#msg+1] = "\n\tno file '" .. fpath .. "'"
      end
      return nil, table_concat(msg)
   end
end

local loadconf = package.searchpath("loadconf", package.path)
loadconf       = io.open(loadconf):read('*a')
local flirt    = package.searchpath("flirt", package.path)
flirt          = io.open(flirt):read('*a')

local rev = io.popen("git describe --always"):read('*a')

local function license()
   print("--[[ generated on " .. os.date() .. " rev " .. rev)
   io.write(io.open("LICENSE.md"):read('*a'))
   print("]]--")
end

print("#!/usr/bin/env lua")
license()
print("do")
print((loadconf:gsub("return loadconf%s*$", "package.loaded.loadconf = loadconf")))
print("end")
print("do")
print((flirt:gsub("return %b{}%s*$", "main(...)")))
print("end")

