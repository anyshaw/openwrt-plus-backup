local fs = require "nixio.fs"
local util = require "nixio.util"
local dnsfilter_status=(luci.sys.call("[ -f /etc/dnsmasq.d/dnsfilter.conf ]") == 0)
local button=""
------------------------------------------------------------------------
if dnsfilter_status then
	m = Map("dnsfilter", translate("dnsfilter"), translate("Filtering rules [Enabled]") .. button)
else
	m = Map("dnsfilter", translate("dnsfilter"), translate("Filtering rules [disabled]"))
end
------------------------------------------------------------------------
s = m:section(TypedSection, "dnsfilter", translate("Configuring DNS Filter"))
s.anonymous = true

s:tab("basic",  translate("Basic Settings"))
------------------------------------------------------------------------
button_update = s:taboption("basic", Button, "_button_update" ,translate("Manual Update"))
button_update.inputtitle = translate("Update filtering rules")
button_update.inputstyle = "apply"
function button_update.write(self, section)
	luci.sys.call("screen -S DNS -dm bash dns update")
end
------------------------------------------------------------------------
enable = s:taboption("basic", Flag, "enabled", translate("Enabled dnsfilter"))
enable.rmempty = false

adblock = s:taboption("basic", Flag, "adblock", translate("Enabled AdBlock Ruls Subscribe"))
adblock.rmempty = false

hosts = s:taboption("basic", Flag, "hosts", translate("Enabled HOSTS Subscribe"))
hosts.rmempty = false

autoupdate = s:taboption("basic", Flag, "autoupdate", translate("Enable automatic updates"))
autoupdate.rmempty = false

proxy = s:taboption("basic", Flag, "proxy", translate("Use proxy"))
proxy.rmempty = false
--AdBlock---------------------------------------------------------------
s:tab("editconf_adblock", translate("AdBlock list"))
editconf_adblock = s:taboption("editconf_adblock", Value, "_editconf_adblock", 
	translate("Edit the right side list"), 
	translate("Comments use '#'"))
editconf_adblock.template = "cbi/tvalue"
editconf_adblock.rows = 20
editconf_adblock.wrap = "off"

function editconf_adblock.cfgvalue(self, section)
	return fs.readfile("/etc/dnsfilter/conf/adb_rules.txt") or ""
end
function editconf_adblock.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/adb_rules.txt", value)
		if (luci.sys.call("cmp -s /tmp/adb_rules.txt /etc/dnsfilter/conf/adb_rules.txt") == 1) then
			fs.writefile("/etc/dnsfilter/conf/adb_rules.txt", value)
		end
		fs.remove("/tmp/adb_rules.txt")
	end
end
--HOSTS-----------------------------------------------------------------
s:tab("editconf_hosts", translate("HOSTS Subscribe List"))
editconf_hosts = s:taboption("editconf_hosts", Value, "_editconf_hosts", 
	translate("Edit the right side list"), 
	translate("Comments use '#'"))
editconf_hosts.template = "cbi/tvalue"
editconf_hosts.rows = 20
editconf_hosts.wrap = "off"

function editconf_hosts.cfgvalue(self, section)
	return fs.readfile("/etc/dnsfilter/conf/hosts_rules.txt") or ""
end
function editconf_hosts.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/hosts_rules.txt", value)
		if (luci.sys.call("cmp -s /tmp/hosts_rules.txt /etc/dnsfilter/conf/hosts_rules.txt") == 1) then
			fs.writefile("/etc/dnsfilter/conf/hosts_rules.txt", value)
		end
		fs.remove("/tmp/hosts_rules.txt")
	end
end
--Block-----------------------------------------------------------------
s:tab("editconf_block", translate("Local filtering rules"))
editconf_block = s:taboption("editconf_block", Value, "_editconf_block", 
	translate("Edit the right side list"), 
	translate("Comments use '#'"))
editconf_block.template = "cbi/tvalue"
editconf_block.rows = 20
editconf_block.wrap = "off"

function editconf_block.cfgvalue(self, section)
	return fs.readfile("/etc/dnsfilter/block.txt") or ""
end
function editconf_block.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/block.txt", value)
		if (luci.sys.call("cmp -s /tmp/block.txt /etc/dnsfilter/block.txt") == 1) then
			fs.writefile("/etc/dnsfilter/block.txt", value)
		end
		fs.remove("/tmp/block.txt")
	end
end
--Fix-------------------------------------------------------------------
s:tab("editconf_fix", translate("Local parsing rules"))
editconf_fix = s:taboption("editconf_fix", Value, "_editconf_fix", 
	translate("Edit the right side list"), 
	translate("Comments use '#'"))
editconf_fix.template = "cbi/tvalue"
editconf_fix.rows = 20
editconf_fix.wrap = "off"

function editconf_fix.cfgvalue(self, section)
	return fs.readfile("/etc/dnsfilter/fix.txt") or ""
end
function editconf_fix.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/fix.txt", value)
		if (luci.sys.call("cmp -s /tmp/fix.txt /etc/dnsfilter/fix.txt") == 1) then
			fs.writefile("/etc/dnsfilter/fix.txt", value)
		end
		fs.remove("/tmp/fix.txt")
	end
end
--Hijacking-------------------------------------------------------------
s:tab("editconf_hijacking", translate("Local anti-DNS hijacking rules"))
editconf_hijacking = s:taboption("editconf_hijacking", Value, "_editconf_hijacking", 
	translate("Edit the right side list"), 
	translate("Comments use '#'"))
editconf_hijacking.template = "cbi/tvalue"
editconf_hijacking.rows = 20
editconf_hijacking.wrap = "off"

function editconf_hijacking.cfgvalue(self, section)
	return fs.readfile("/etc/dnsfilter/Prevent_DNS_Hijacking.txt") or ""
end
function editconf_hijacking.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/Prevent_DNS_Hijacking.txt", value)
		if (luci.sys.call("cmp -s /tmp/Prevent_DNS_Hijacking.txt /etc/dnsfilter/Prevent_DNS_Hijacking.txt") == 1) then
			fs.writefile("/etc/dnsfilter/Prevent_DNS_Hijacking.txt", value)
		end
		fs.remove("/tmp/Prevent_DNS_Hijacking.txt")
	end
end
--White List------------------------------------------------------------
s:tab("editconf_whitelist", translate("White lists"))
editconf_whitelist = s:taboption("editconf_whitelist", Value, "_editconf_whitelist", 
	translate("Edit the right side list"), 
	translate("Comments use '#'"))
editconf_whitelist.template = "cbi/tvalue"
editconf_whitelist.rows = 20
editconf_whitelist.wrap = "off"

function editconf_whitelist.cfgvalue(self, section)
	return fs.readfile("/etc/dnsfilter/white_list.txt") or ""
end
function editconf_whitelist.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/white_list.txt", value)
		if (luci.sys.call("cmp -s /tmp/white_list.txt /etc/dnsfilter/white_list.txt") == 1) then
			fs.writefile("/etc/dnsfilter/white_list.txt", value)
		end
		fs.remove("/tmp/white_list.txt")
	end
end
--GFW List------------------------------------------------------------
s:tab("editconf_gfwlist", translate("GFW lists"))
editconf_gfwlist = s:taboption("editconf_gfwlist", Value, "_editconf_gfwlist", 
	translate("Edit the right side list"), 
	translate("Comments use '#'"))
editconf_gfwlist.template = "cbi/tvalue"
editconf_gfwlist.rows = 20
editconf_gfwlist.wrap = "off"

function editconf_gfwlist.cfgvalue(self, section)
	return fs.readfile("/etc/dnsmasq.d/gfw.conf") or ""
end
function editconf_gfwlist.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/gfw.conf.tmp", value)
		if (luci.sys.call("cmp -s /tmp/gfw.conf.tmp /etc/dnsmasq.d/gfw.conf") == 1) then
			fs.writefile("/etc/dnsmasq.d/gfw.conf", value)
		end
		fs.remove("/tmp/gfw.conf.tmp")
	end
end
--Log-------------------------------------------------------------------
s:tab("editconf_log", translate("Logs"))
editconf_log = s:taboption("editconf_log", Value, "_editconf_log")
editconf_log.template = "cbi/tvalue"
editconf_log.rows = 20
editconf_log.wrap = "off"
editconf_log.rmempty = false

function editconf_log.cfgvalue(self, section)
	return fs.readfile("/etc/dnsfilter/log/dns_update.log") or ""
end
function editconf_log.write(self, section, value)
end
------------------------------------------------------------------------
return m
