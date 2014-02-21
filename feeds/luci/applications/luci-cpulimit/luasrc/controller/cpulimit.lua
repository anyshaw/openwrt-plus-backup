--[[
LuCI - Lua Configuration Interface

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0
]]--

module("luci.controller.cpulimit", package.seeall)

function index()
	require("luci.i18n")
	luci.i18n.loadc("cpulimit")
	if not nixio.fs.access("/etc/config/cpulimit") then
		return
	end
	
	local page = entry({"admin", "services", "cpulimit"}, cbi("cpulimit"), luci.i18n.translate("cpulimit"))
	page.i18n = "cpulimit"
	page.dependent = true
	
end
