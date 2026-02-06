-- Streaming privacy: blur window when sensitive files are open
-- Integrates with OBS via streaming-blur.sh to overlay a pixelated blur
-- when editing .env files or other sensitive content during streams.
--
-- AGGRESSIVE MODE: Blur stays on as long as ANY sensitive buffer is loaded.
-- This prevents flashing when switching between sensitive and normal files.

return {
  {
    dir = "~", -- virtual plugin, no actual plugin needed
    event = { "BufReadPre", "BufEnter", "BufDelete", "BufWipeout" },
    config = function()
      -- Delay after triggering blur before loading file (ms) - gives shader time to activate
      local blur_on_delay_ms = 50

      -- File patterns that should trigger blur
      local patterns = {
        ".env",
        "*.env",
        ".env.*",
        "*.env.*",
        "*credentials*",
        "*secret*",
        "*.pem",
        "*.key",
        "*password*",
      }

      -- Track blur state and sensitive buffers
      local blur_active = false
      local sensitive_buffers = {} -- Set of buffer numbers with sensitive files

      -- Check if streaming mode is active
      local function is_streaming()
        return vim.fn.filereadable("/tmp/streaming-mode-active") == 1
      end

      -- Check if OBS is running (blur only works with OBS)
      local function is_obs_running()
        local handle = io.popen("pgrep -x obs 2>/dev/null")
        if handle then
          local result = handle:read("*a")
          handle:close()
          return result ~= ""
        end
        return false
      end

      -- Path to the blur script
      local blur_script = vim.fn.expand("~/dotfiles/scripts/streaming-blur.sh")

      -- Activate blur overlay (or update position if already active)
      local function blur_on(update_position)
        if not is_streaming() or not is_obs_running() then
          return
        end
        if not blur_active then
          vim.fn.jobstart({ blur_script, "on" }, { detach = true })
          blur_active = true
        elseif update_position then
          -- Re-trigger to update window position with daemon
          vim.fn.jobstart({ blur_script, "on" }, { detach = true })
        end
      end

      -- Deactivate blur overlay
      local function blur_off()
        if blur_active then
          vim.fn.jobstart({ blur_script, "off" }, { detach = true })
          blur_active = false
        end
      end

      -- Count sensitive buffers
      local function has_sensitive_buffers()
        return next(sensitive_buffers) ~= nil
      end

      -- Register a buffer as sensitive
      local function register_sensitive_buffer(bufnr)
        if not sensitive_buffers[bufnr] then
          sensitive_buffers[bufnr] = true
          blur_on()
        end
      end

      -- Unregister a buffer as sensitive
      local function unregister_sensitive_buffer(bufnr)
        sensitive_buffers[bufnr] = nil
        -- Only turn off blur if no sensitive buffers remain
        if not has_sensitive_buffers() then
          blur_off()
        end
      end

      -- Create autocmd group
      local group = vim.api.nvim_create_augroup("StreamingPrivacy", { clear = true })

      -- Blur BEFORE file content loads (catches new file opens early)
      vim.api.nvim_create_autocmd("BufReadPre", {
        group = group,
        pattern = patterns,
        callback = function(ev)
          register_sensitive_buffer(ev.buf)
          -- Wait for shader to activate before file content loads
          vim.wait(blur_on_delay_ms)
        end,
        desc = "Blur window before sensitive file content loads",
      })

      -- Also register on enter and update blur position (for splits, window changes, etc.)
      vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        pattern = patterns,
        callback = function(ev)
          local already_tracked = sensitive_buffers[ev.buf]
          register_sensitive_buffer(ev.buf)
          -- Always update position when entering a sensitive buffer
          if already_tracked then
            blur_on(true) -- update position
          end
        end,
        desc = "Ensure blur is on and positioned when entering sensitive files",
      })

      -- Unregister when buffer is deleted/wiped
      vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
        group = group,
        callback = function(ev)
          -- Check if this buffer was sensitive
          if sensitive_buffers[ev.buf] then
            unregister_sensitive_buffer(ev.buf)
          end
        end,
        desc = "Unblur when sensitive buffer is closed",
      })

      -- Also unblur on VimLeave to clean up
      vim.api.nvim_create_autocmd("VimLeave", {
        group = group,
        callback = function()
          if blur_active then
            -- Use synchronous call on exit to ensure cleanup
            vim.fn.system({ blur_script, "off" })
          end
        end,
        desc = "Ensure blur is off when exiting Neovim",
      })

      -- Command to manually toggle blur
      vim.api.nvim_create_user_command("StreamingBlur", function(opts)
        local arg = opts.args
        if arg == "on" then
          blur_active = false -- Force state reset
          blur_on()
        elseif arg == "off" then
          blur_active = true -- Force state reset
          blur_off()
        elseif arg == "toggle" then
          if blur_active then
            blur_off()
          else
            blur_on()
          end
        else
          local count = 0
          for _ in pairs(sensitive_buffers) do
            count = count + 1
          end
          local status = blur_active and "ON" or "OFF"
          vim.notify(string.format("Streaming blur: %s (%d sensitive buffers)", status, count), vim.log.levels.INFO)
        end
      end, {
        nargs = "?",
        complete = function()
          return { "on", "off", "toggle", "status" }
        end,
        desc = "Control streaming privacy blur",
      })
    end,
  },
}
