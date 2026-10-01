-- Color palette module
-- Baseline: Catppuccin Mocha. Overridden at runtime by theme-switch
-- which writes colors_override.lua (a Lua table of the active palette).

local C = {
    -- Catppuccin Mocha baseline (used when no theme has been applied)
    background     = "rgb(1e1e2e)",
    background_alt = "rgb(313244)",
    background_dark = "rgb(181825)",
    foreground     = "rgb(cdd6f4)",
    foreground_dim = "rgb(bac2de)",
    cursor         = "rgb(f5e0dc)",

    black          = "rgb(45475a)",
    red            = "rgb(f38ba8)",
    green          = "rgb(a6e3a1)",
    yellow         = "rgb(f9e2af)",
    blue           = "rgb(89b4fa)",
    magenta        = "rgb(f5c2e7)",
    cyan           = "rgb(94e2d5)",
    white          = "rgb(bac2de)",

    bright_black   = "rgb(585b70)",
    bright_red     = "rgb(f38ba8)",
    bright_green   = "rgb(a6e3a1)",
    bright_yellow  = "rgb(f9e2af)",
    bright_blue    = "rgb(89b4fa)",
    bright_magenta = "rgb(f5c2e7)",
    bright_cyan    = "rgb(94e2d5)",
    bright_white   = "rgb(a6adc8)",

    accent         = "rgb(f9e2af)",
    accent_bright  = "rgb(f9e2af)",
    border         = "rgb(cba6f7)",
    separator      = "rgb(45475a)",

    surface0       = "rgb(313244)",
    surface1       = "rgb(45475a)",
    surface2       = "rgb(585b70)",
}

-- Apply overrides from theme-switch.
-- theme-switch generates colors_override.lua returning a table of the same
-- keys as C above. Overlay any values it provides onto the baseline.
local override_path = os.getenv("HOME") .. "/.config/hypr/colors_override.lua"
local ok, overrides = pcall(dofile, override_path)
if ok and type(overrides) == "table" then
    for k, v in pairs(overrides) do
        C[k] = v
    end
end

return C
