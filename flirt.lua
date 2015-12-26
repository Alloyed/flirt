-- FIXME
local config_path = ("%s/.config/flirt/conf.lua"):format(os.getenv("HOME"))

local config = {
   stable = "0.10.0", -- versions past this number are considered prerelease
}

local function fail(...)
   io.stderr:write("Error: " .. string.format(...) .. "\n")
   io.stderr:flush()
end

local function log(...)
   io.stdout:write("flirt: " .. string.format(...) .. "\n")
   io.stdout:flush()
end

local function load_versions()
   local chunk, err = loadfile(config_path)
   if chunk then
      local t = chunk()
      for k, v in pairs(t) do
         config[k] = v
      end
   end
end

local function save_versions()
   local dir = config_path:gsub("/conf.lua$", "")
   assert(os.execute(("mkdir -p %q"):format(dir))) -- FIXME
   local f = assert(io.open(config_path, 'w'))
   local s_pairs = {}
   for k, v in pairs(config) do
      table.insert(s_pairs, string.format("[%q] = %q", k, v))
   end
   f:write("return {\n\t" .. table.concat(s_pairs, ",\n\t") .. "\n}")
   f:close()
   log("config saved to %q", config_path)
end

local loadconf = require 'loadconf'

local function sopen(exec_str)
   local f, err = io.popen(exec_str)
   if not f then return nil, err end

   str, err = f:read('*a')
   if not str then return nil, err end

   f:close()
   return str
end

local function which(exe)
   return sopen(string.format("which '%s' 2> /dev/null", exe)) -- FIXME
end

local names = {
   "love",
   "love07",
   "love08",
   "love09",
   "love-hg"
}

local function trim(s)
   return (s:gsub("^%s+",""):gsub("%s+$", ""))
end

-- Find version for a love exe by running a dummy project
local function get_version_for(exe)
   local dummy = "/tmp/flirt_dummy_project"
   -- FIXME: delete later
   os.execute(("mkdir -p %q"):format(dummy))

   assert(io.open(dummy .. "/conf.lua", "w")):write([[
   print(string.format('flirt(%d.%d.%d)',
         love._version_major, love._version_minor, love._version_revision))
   os.exit()
   ]])

   local s = sopen(string.format("%q %q", exe, dummy))
   if s and s ~= "" then
      local v = s:match("flirt(%b())")
      if v then
         return v:sub(2, -2)
      end
   end
   return nil, ("invalid executable: %q"):format(exe)
end

local function add_exe(s)
   local v, err = get_version_for(s)
   if not v then
      return v, err
   end
   log("found LOVE %s at %q", v, s)
   config[v] = s
   return true
end

local function guess()
   for _, name in ipairs(names) do
      local s = which(name)
      if s and s ~= "" then
         s = trim(s)
         add_exe(s)
      end
   end
end

local function exists(fname)
   local f, err = io.open(fname) -- FIXME: does not work in windows
   if f then
      f:close()
      return true
   end
   return false
end

local function is_dir(fname)
   return os.execute(string.format("test -d %q", fname)) or false -- FIXME
end

local function vsplit(v)
   local maj, min, rev = string.match(v, "(%d+)%.(%d+)%.(%d+)")
   return tonumber(maj), tonumber(min), tonumber(rev)
end

local function best_exe_for(version)
   if config[version] then
      return config[version]
   end
   local maj, min, rev = vsplit(version)
   for v, path in pairs(config) do
      if not v == 'stable' then
         local imaj, imin, irev = vsplit(v)
         if imaj == maj and imin == min and irev > rev then -- better patch
            return path
         end
      end
   end
   return nil
end

local function gt(a, b)
   if a == nil then
      return false
   elseif b == nil then
      return true
   end

   local amaj, amin, arev = vsplit(a)
   local bmaj, bmin, brev = vsplit(b)
   if amaj ~= bmaj then
      return amaj > bmaj
   elseif amin ~= bmin then
      return amin > bmin
   else
      return arev > brev
   end
end

local function most_recent()
   local c = nil
   local stable = config.stable
   for v, _ in pairs(config) do
      if v ~= "stable" then
         if gt(v, c) and not gt(v, stable) then
            c = v
         end
      end
   end

   return c
end

--- Given the filename of a .love archive, returns a table containing its
--  configuration. Requires UnZip to be installed to your path.
--  @param fname The path to the .love file
--  @return the configuration table, or `nil, err` if an error occured.
local function parse_archive(fname)
   -- FIXME: use a proper cross-platform zip library
   local f, err = io.popen(("unzip -p %q conf.lua 2> /dev/null"):format(fname))
   if not f then return nil, err end

   str, err = f:read('*a')
   if not str then return nil, err end

   f:close()

   return loadconf.parse_string(str)
end

local function bash_escape(s)
   return s:gsub("\"", "\\\""):gsub("^~", os.getenv("HOME"))
end

local function run(...)
   local s = ""
   local sep = ""
   for i=1, select('#', ...) do
      s = s .. sep
      s = s .. "\"" .. bash_escape(select(i, ...)) .. "\""
      sep = " "
   end
   return os.execute(s)
end

local function main(...)
   load_versions()
   assert(config.stable)

   local fname = ...
   local version = config.stable
   if fname == "--autoconf" then
      guess()
      save_versions()
      return
   elseif fname == "--add-exe" then
      assert(add_exe((select(2, ...))))
      save_versions()
      return
   elseif fname ~= nil and exists(fname) then
      if is_dir(fname) and exists(fname .. "/conf.lua") then
         version = assert(loadconf.parse_file(fname.."/conf.lua")).version
      else
         version = assert(parse_archive(fname)).version
      end

      if version == nil then -- no version specified
         version = most_recent()
      end
   end

   local p = best_exe_for(version)
   if not p then
      fail("No LOVE executable for version " .. version)
      return
   end

   run(p, ...)
   return
end

return { main = main }
