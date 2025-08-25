rule = {
	matches = {
		{
			{ "node.name", "matches", "alsa_output.pci-0000_18_00.6.analog-stereo" },
		},
	},
	apply_properties = {
		["node.description"] = "Desktop Speakers",
		["device.description"] = "Desktop Speakers",
	},
}

table.insert(alsa_monitor.rules, rule)
