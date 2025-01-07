return {
  "nvimdev/dashboard-nvim",
  lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
  opts = function()
    local logo = [[
              ...     ...                                        .....     .                   .x+=:.               
            .=*8888n.."%888:                                    .d88888Neu. 'L                 z`    ^%             
          X    ?8888f '8888          u.      uL   ..           F""""*8888888F  .d``              .   <k        u.   
          88x. '8888X  8888>   ...ue888b   .@88b  @88R        *      `"*88*"   @8Ne.   .u      .@8Ned8"  ...ue888b  
          '8888k 8888X  '"*8h.  888R Y888r '"Y888k/"*P          -....    ue=:.  %8888:u@88N   .@^%8888"   888R Y888r
          "8888 X888X .xH8     888R I888>    Y888L                    :88N  `   `888I  888. x88:  `)8b.  888R I888> 
            `8" X888!:888X     888R I888>     8888                    9888L      888I  888I 8888N=*8888  888R I888> 
            =~`  X888 X888X     888R I888>     `888N            uzu.   `8888L     888I  888I  %8"    R88  888R I888>
            :h. X8*` !888X    u8888cJ888   .u./"888&         ,""888i   ?8888   uW888L  888'   @8Wou 9%  u8888cJ888  
            X888xX"   '8888..:  "*888*P"   d888" Y888*"       4  9888L   %888> '*88888Nu88P  .888888P`    "*888*P"  
          :~`888f     '*888*"     'Y"      ` "Y   Y"          '  '8888   '88%  ~ '88888F`    `   ^"F        'Y"     
              ""        `"`                                        "*8Nu.z*"      888 ^                             
                                                                                  *8E                               
                                                                                  '8>                               
                                                                                  "                                 
    ]]

    logo = string.rep("\n", 8) .. logo .. "\n\n"

    local opts = {
      theme = "doom",
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = vim.split(logo, "\n"),
        -- stylua: ignore
        center = {
          { action = 'lua LazyVim.pick()()',                           desc = " Find File",       icon = " ", key = "f" },
          { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
          { action = 'lua LazyVim.pick("oldfiles")()',                 desc = " Recent Files",    icon = " ", key = "r" },
          { action = 'lua LazyVim.pick("live_grep")()',                desc = " Find Text",       icon = " ", key = "g" },
          { action = 'lua LazyVim.pick.config_files()()',              desc = " Config",          icon = " ", key = "c" },
          { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "s" },
          { action = "LazyExtras",                                     desc = " Lazy Extras",     icon = " ", key = "x" },
          { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
          { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- open dashboard after closing lazy
    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end

    return opts
  end,
}
