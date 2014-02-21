--[[
RA-MOD
]]--

local fs = require "nixio.fs"

local running=(luci.sys.call("pidof gmediarender > /dev/null") == 0)
if running then	
	m = Map("gmediarender", translate("gmediarender"), translate("gmediarender is running"))
else
	m = Map("gmediarender", translate("gmediarender"), translate("gmediarender is not running"))
end

s = m:section(TypedSection, "gmediarender", "")
s.anonymous = true

switch = s:option(Flag, "enabled", translate("Enable"))
switch.rmempty = false

editconf = s:option(Value, "_data", " ")
editconf.template = "cbi/tvalue"
editconf.rows = 25
editconf.wrap = "off"

function editconf.cfgvalue(self, section)
	return fs.readfile("/etc/config/gmediaplay") or ""
end
function editconf.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/gmediaplay", value)
		if (luci.sys.call("cmp -s /tmp/gmediaplay /etc/config/gmediaplay") == 1) then
			fs.writefile("/etc/config/gmediaplay", value)
		end
		fs.remove("/tmp/gmediaplay")
	end
end

return m
