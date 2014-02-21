--[[
LuCI - Lua Configuration Interface

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0
]]--

module("luci.controller.shairport", package.seeall)

function index()

	if not nixio.fs.access("/etc/config/airplay") then
		return
	end

	local page
	page = entry({"admin", "services", "shairport"}, cbi("shairport"), _("shairport"))
	page.i18n = "shairport"
	page.dependent = true
end
