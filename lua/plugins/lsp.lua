return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "DanielGavin/ols",
      "simrat39/rust-tools.nvim",
    },
    opts = {
      servers = {
        ols = {},
        rust_analyzer = {},
      },
      setup = {
        rust_analyzer = function(_, opts)
          require("rust-tools").setup({ server = opts })
          return true
        end,
      },
    },
  },
}
