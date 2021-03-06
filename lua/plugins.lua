vim.cmd([[packadd packer.nvim]])

-- plugins
require("packer").startup(function(use)
  local local_use = function(path, opts)
    opts = opts or {}
    if vim.fn.isdirectory(vim.fn.expand("~/plugins/" .. path)) == 1 then
      opts[1] = "~/plugins/" .. path
      use(opts)
    else
      error(string.format("Local plugin %s was not found", path))
    end
  end

  use({ "wbthomason/packer.nvim" })

  -- Local plugins
  local_use("stylua.nvim")
  local_use("telescope-windowizer.nvim")
  local_use("notes.nvim")

  -- Code completion
  use({ "hrsh7th/nvim-cmp" })
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/cmp-buffer" })
  use({ "hrsh7th/cmp-path" })
  use({ "saadparwaiz1/cmp_luasnip" })

  use({ "neovim/nvim-lspconfig" })
  use({ "nvim-lua/lsp_extensions.nvim" })
  use({ "onsails/lspkind-nvim" })

  -- Languages
  use({ "olexsmir/gopher.nvim" })

  -- Sql
  use({ "tpope/vim-dadbod" })
  use({ "kristijanhusak/vim-dadbod-completion" })
  use({ "kristijanhusak/vim-dadbod-ui" })

  -- Diagnostics
  use({ "j-hui/fidget.nvim" })
  use({ "folke/lsp-trouble.nvim", cmd = "Trouble" })

  -- Focusing
  use({ "folke/zen-mode.nvim" })
  use({ "folke/twilight.nvim" })

  -- Snippet
  use({ "L3MON4D3/LuaSnip" })
  use({ "rafamadriz/friendly-snippets" })

  -- Syntax
  use({ "nvim-treesitter/nvim-treesitter-textobjects" })
  use({ "nvim-treesitter/nvim-treesitter" })
  use({ "nvim-treesitter/playground" })

  -- Presentation
  use({ "kyazdani42/nvim-tree.lua" })
  use({ "RRethy/vim-illuminate" })
  use({ "tpope/vim-fugitive" })
  use({ "nvim-lualine/lualine.nvim" })
  use({ "lewis6991/gitsigns.nvim" })
  use({ "lukas-reineke/indent-blankline.nvim" })
  use({ "alvarosevilla95/luatab.nvim" })
  use({ "karb94/neoscroll.nvim" })
  use({
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
    end,
  })

  -- General plugins
  use({ "godlygeek/tabular" })
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })
  use({ "tpope/vim-surround" })
  use({ "tpope/vim-endwise" })
  use({ "mg979/vim-visual-multi", branch = "master" })
  use({ "matze/vim-move" })
  use({ "windwp/nvim-autopairs" })
  use({ "mbbill/undotree" })
  use({
    "andweeb/presence.nvim",
    config = function()
      require("presence"):setup()
    end,
  })

  use({
    "prettier/vim-prettier",
    run = "yarn install --frozen-lockfile --production",
  })

  -- Themes
  use({ "kyazdani42/nvim-web-devicons" })
  use({ "gruvbox-community/gruvbox" })
  use({
    "catppuccin/nvim",
    as = "catppuccin",
  })
  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  })

  -- Searching and navigation
  use({ "nvim-lua/popup.nvim" })
  use({ "nvim-lua/plenary.nvim" })
  use({ "nvim-telescope/telescope.nvim" })
  use({ "nvim-telescope/telescope-fzy-native.nvim" })
  use({ "nvim-telescope/telescope-project.nvim" })
  use({ "nvim-telescope/telescope-file-browser.nvim" })
  use({ "ThePrimeagen/harpoon" })

  use({ "sbdchd/neoformat" })
  use({ "christoomey/vim-tmux-navigator" })
  use({ "vim-test/vim-test" })
  use({ "lewis6991/impatient.nvim" })
end)

require("plugins.catppuccin")
require("plugins.autopairs")
require("plugins.fidget")
require("plugins.gitsigns")
require("plugins.lsp")
require("plugins.lualine")
require("plugins.luatab")
require("plugins.indent-blankline")
require("plugins.neoscroll")
require("plugins.nvim-tree")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.trouble")
require("plugins.zenmode")
