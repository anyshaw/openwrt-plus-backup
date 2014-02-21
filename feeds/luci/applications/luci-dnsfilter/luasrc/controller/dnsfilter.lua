--[[
LuCI - Lua Configuration Interface

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0
]]--

module("luci.controller.dnsfilter", package.seeall)

function index()
	require("luci.i18n")
	luci.i18n.loadc("cpulimit")
	if not nixio.fs.access("/etc/config/dnsfilter") then
		return
	end

	local page = entry({"admin", "services", "dnsfilter"}, cbi("dnsfilter"), _("dnsfilter"))
	page.i18n = "dnsfilter"
	page.dependent = true
	
end
