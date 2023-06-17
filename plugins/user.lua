return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  { "lukas-reineke/indent-blankline.nvim" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup {
        color_overrides = {
          mocha = {
            base = "#000000",
            mantle = "#020202",
            crust = "#040404",
          },
        },
      }
    end,
  },
  -- {
  --   "simrat39/rust-tools.nvim",
  --   ft = "rust",
  --   dependencies = "neovim/nvim-lspconfig",
  --   opts = function() end,
  --   config = function(_, opts) require("rust-tools").setup(opts) end,
  -- },
  {
    "saecki/crates.nvim",
    -- dependencies = "hrsh7th/nvim-cmp",
    ft = { "rust", "toml" },
    config = function(_, opts)
      local crates = require "crates"
      crates.setup(opts)
      -- crates.show()
    end,
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   opts = function()
  --     local M = require "plugins.configs.nvim-cmp"
  --     table.insert(M.sources, { name = "crates" })
  --     return M
  --   end,
  -- },
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   opts = {
  --     user_default_options = {
  --       names = false,
  --       tailwind = "both",
  --     },
  --     -- filetypes = {
  --     --   "*",
  --     --   css = { names = true, css = true, css_fn = true },
  --     -- },
  --   },
  -- },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    opts = function(_, opts)
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item)
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },
  -- {
  --   "js-everts/cmp-tailwind-colors",
  --   opts = function(_, opts)
  --     local kind_icons = {
  --       Text = "",
  --       Method = "",
  --       Function = "",
  --       Constructor = "",
  --       Field = "",
  --       Variable = "",
  --       Class = "ﴯ",
  --       Interface = "",
  --       Module = "",
  --       Property = "ﰠ",
  --       Unit = "",
  --       Value = "",
  --       Enum = "",
  --       Keyword = "",
  --       Snippet = "",
  --       Color = "",
  --       File = "",
  --       Reference = "",
  --       Folder = "",
  --       EnumMember = "",
  --       Constant = "",
  --       Struct = "",
  --       Event = "",
  --       Operator = "",
  --       TypeParameter = "",
  --     }
  --
  --     opts.formatting = {
  --       fields = { "kind", "abbr", "menu" }, -- order of columns
  --       format = function(entry, item)
  --         if item.kind == "Color" then
  --           item = require("cmp-tailwind-colors").format(entry, item)
  --
  --           if item.kind ~= "Color" then
  --             item.menu = "Color"
  --             return item
  --           end
  --         end
  --
  --         item.menu = item.kind
  --         item.kind = kind_icons[item.kind] .. " "
  --         return item
  --       end,
  --     }
  --   end,
  -- },
}
