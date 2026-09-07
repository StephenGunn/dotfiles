-- Streaming mode workspace gaps
-- streaming-mode.sh generates streaming_gen.lua with hl.workspace_rule() calls.
-- This module loads it if present.

local gen = os.getenv("HOME") .. "/.config/hypr/streaming_gen.lua"
local f = io.open(gen, "r")
if f then
    f:close()
    dofile(gen)
end
