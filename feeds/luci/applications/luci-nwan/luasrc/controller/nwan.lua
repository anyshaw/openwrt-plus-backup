--[[
LuCI - Lua Configuration Interface

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0
]]--

module("luci.controller.nwan", package.seeall)

function index()

	if nixio.fs.access("/etc/config/nwan") then

	local page 	
	page = entry({"admin", "services", "nwan"}, cbi("nwan/nwan"), _("N-WAN"))
	page.i18n = "nwan"
	page.dependent = true
	end

	if nixio.fs.access("/etc/config/nwannumset") then
	local page 
	page = entry({"admin", "services", "nwannumset"}, cbi("nwan/nwannumset"), _("macvlan"))
	page.i18n = "nwan"
	page.dependent = true
	end


end
