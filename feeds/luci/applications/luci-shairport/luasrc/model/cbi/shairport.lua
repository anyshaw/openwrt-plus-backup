--[[
RA-MOD
]]--

local fs = require "nixio.fs"

local running=(luci.sys.call("pidof shairport > /dev/null") == 0)
if running then	
	m = Map("shairport", translate("shairport"), translate("shairport is running"))
else
	m = Map("shairport", translate("shairport"), translate("shairport is not running"))
end

s = m:section(TypedSection, "shairport", "")
s.anonymous = true

switch = s:option(Flag, "enabled", translate("Enable"))
switch.rmempty = false

editconf = s:option(Value, "_data", " ")
editconf.template = "cbi/tvalue"
editconf.rows = 25
editconf.wrap = "off"

function editconf.cfgvalue(self, section)
	return fs.readfile("/etc/config/airplay") or ""
end
function editconf.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/airplay", value)
		if (luci.sys.call("cmp -s /tmp/airplay /etc/config/airplay") == 1) then
			fs.writefile("/etc/config/airplay", value)
		end
		fs.remove("/tmp/airplay")
	end
end

return m
