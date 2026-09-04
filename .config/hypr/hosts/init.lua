-- Host-specific config: monitors + workspaces
-- Detects hostname at runtime instead of relying on symlinks.

local f = io.open("/etc/hostname", "r")
local hostname = f and f:read("*l") or "unknown"
if f then f:close() end

-- Strip any trailing whitespace/newline
hostname = hostname:match("^%s*(.-)%s*$")

local ok, err = pcall(require, "hosts." .. hostname)
if not ok then
    print("[hyprland.lua] WARNING: No host config for '" .. hostname .. "': " .. tostring(err))
end
