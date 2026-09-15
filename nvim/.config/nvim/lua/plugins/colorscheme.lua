return {
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-nvim",
    },
  },

  {
    "catppuccin/nvim",
    lazy = true,
    -- enabled = false,
    name = "catppuccin",
    -- priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false, -- disables setting the background color.
      show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
      term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      no_underline = false, -- Force no underline
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {
        -- mocha = {
        --   base = "#080808",
        --   mantle = "#0c0c12",
        --   crust = "#08080d",
        --
        --   rosewater = "#f5b8b0",
        --   flamingo = "#f29999",
        --   pink = "#f58fd3",
        --   mauve = "#c084f9",
        --   red = "#f36e85",
        --   maroon = "#e46d77",
        --   peach = "#fc9764",
        --   yellow = "#f9db71",
        --   green = "#87e383",
        --   teal = "#6ee4c9",
        --   sky = "#7fcdef",
        --   sapphire = "#5db9ef",
        --   blue = "#6d99f9",
        --   lavender = "#a0a5fd",
        --   text = "#bcc8ff",
        --   subtext1 = "#a9b7ff",
        --   subtext0 = "#97a5ee",
        --   overlay2 = "#82889f",
        --   overlay1 = "#6c7289",
        --   overlay0 = "#575b73",
        --   surface2 = "#3e415b",
        --   surface1 = "#3a3c4e",
        --   surface0 = "#171827",
        -- },
        mocha = {
          base = "#080808",
          mantle = "#0c0c12",
          crust = "#08080d",

          rosewater = "#ff9f96",
          flamingo = "#ff7a7a",
          pink = "#ff6ad9",
          mauve = "#a55cff",
          red = "#ff4967",
          maroon = "#e14c57",
          peach = "#ff8141",
          yellow = "#ffd642",
          green = "#5ff15a",
          teal = "#34edc4",
          sky = "#51c9ff",
          sapphire = "#25b2ff",
          blue = "#4788ff",
          lavender = "#858bff",
          text = "#c7d1ff",
          subtext1 = "#b2beff",
          subtext0 = "#a0aeff",
          overlay2 = "#888fa9",
          overlay1 = "#727899",
          overlay0 = "#5f6480",
          surface2 = "#454866",
          surface1 = "#3f4159",
          surface0 = "#141527",
        },
      },
      custom_highlights = function(C)
        local U = require("catppuccin.utils.colors")
        return {
          DiffChange = { bg = U.darken(C.blue, 0.14, C.base) },
          DiffText = { bg = U.darken(C.blue, 0.36, C.base) },
        }
      end,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
          inlay_hints = {
            background = true,
          },
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        aerial = true,
        alpha = true,
        dashboard = true,
        flash = true,
        grug_far = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        semantic_tokens = true,
        telescope = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
}
