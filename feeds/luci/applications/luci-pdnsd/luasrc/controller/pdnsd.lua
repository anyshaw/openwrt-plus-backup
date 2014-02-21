--[[
LuCI - Lua Configuration Interface

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0
]]--

module("luci.controller.pdnsd", package.seeall)

function index()
	
	if not nixio.fs.access("/etc/pdnsd.conf") then
		return
	end

	local page
	page = entry({"admin", "services", "pdnsd"}, cbi("pdnsd"), _("pdnsd"))
	page.i18n = "pdnsd"
	page.dependent = true
end
