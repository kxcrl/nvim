return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = {
        preset = "super-tab",
        ["<Enter>"] = {
          require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
          LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
          "fallback",
        },
        ["<Tab>"] = {
          require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
          LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
          "fallback",
        },
      }
    end,
  },
}
