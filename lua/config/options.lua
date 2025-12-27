-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.visualbell = false

-- Run local hot reload scripts
vim.keymap.set("n", "<F5>", function()
  local output = {}
  local cwd = vim.fn.getcwd()
  local project_name = vim.fn.fnamemodify(cwd, ":t")
  local is_windows = vim.fn.has("win32") == 1

  -- Detect platform and set build command
  local build_cmd
  if is_windows then
    build_cmd = { "cmd.exe", "/c", "build_hot.bat" }
  else
    build_cmd = { "sh", "./build_hot.sh" }
  end

  vim.fn.jobstart(build_cmd, {
    cwd = cwd,
    stdout_buffered = true,
    stderr_buffered = true,

    on_stdout = function(_, data)
      if data then
        vim.list_extend(output, data)
      end
    end,

    on_stderr = function(_, data)
      if data then
        vim.list_extend(output, data)
      end
    end,

    on_exit = function(_, exit_code)
      local message = table.concat(
        vim.tbl_filter(function(line)
          return line ~= ""
        end, output),
        "\n"
      )
      if message == "" then
        message = exit_code == 0 and "Build succeeded" or "Build failed"
      end

      vim.schedule(function()
        if exit_code == 0 then
          vim.notify(message, vim.log.levels.INFO, { title = "Build" })

          -- Run the executable
          local run_cmd
          if is_windows then
            run_cmd = { "cmd.exe", "/c", project_name .. ".exe" }
          else
            run_cmd = { "./" .. project_name }
          end

          vim.fn.jobstart(run_cmd, { cwd = cwd })
        else
          vim.notify(message, vim.log.levels.ERROR, { title = "Build" })
        end
      end)
    end,
  })
end, { desc = "Build and run" })
