vim.cmd([[packadd packer.nvim]])

-- plugins
require("packer").startup(function(use)
  local local_use = function(path, callback, opts)
    opts = opts or {}
    if vim.fn.isdirectory(vim.fn.expand("~/plugins/" .. path)) == 1 then
      opts[1] = "~/plugins/" .. path
      use(opts)
    else
      opts[1] = callback
      use(opts)
    end
  end

  use({ "wbthomason/packer.nvim" })

  -- Local plugins
  local_use("stylua.nvim", "wesleimp/stylua.nvim")
  local_use("elixir-tools.nvim", "elixir-tools/elixir-tools.nvim")
  local_use("sitrusbuddy.nvim", "wesleimp/sitrusbuddy.nvim")

  use({ "williamboman/mason.nvim" })
  use({ "williamboman/mason-lspconfig.nvim" })
  use({ "neovim/nvim-lspconfig" })

  -- Code completion
  use({ "hrsh7th/nvim-cmp" })
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/cmp-buffer" })
  use({ "hrsh7th/cmp-path" })
  use({ "saadparwaiz1/cmp_luasnip" })

  use({ "nvim-lua/lsp_extensions.nvim" })
  use({ "onsails/lspkind-nvim" })
  use({
    "williamboman/nvim-lsp-installer",
    config = function()
      require("nvim-lsp-installer").setup({})
    end,
  })
  use({ "jose-elias-alvarez/null-ls.nvim" })
  use({ "lvimuser/lsp-inlayhints.nvim" })

  -- Sql
  use({ "tpope/vim-dadbod" })
  use({ "kristijanhusak/vim-dadbod-completion" })
  use({ "kristijanhusak/vim-dadbod-ui" })

  -- Diagnostics
  use({ "j-hui/fidget.nvim" })

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

  -- Git
  use({ "tpope/vim-fugitive" })
  use({ "lewis6991/gitsigns.nvim" })

  -- Presentation
  use({ "RRethy/vim-illuminate" })
  use({ "alvarosevilla95/luatab.nvim" })
  use({ "tjdevries/express_line.nvim" })

  -- General plugins
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })
  use({ "tpope/vim-surround" })
  use({ "tpope/vim-abolish" })
  use({ "mg979/vim-visual-multi", branch = "master" })
  use({ "matze/vim-move" })
  use({ "windwp/nvim-autopairs" })
  use({ "mbbill/undotree" })

  use({
    "prettier/vim-prettier",
    run = "yarn install --frozen-lockfile --production",
  })

  -- Themes
  use({ "kyazdani42/nvim-web-devicons" })
  use({ "ellisonleao/gruvbox.nvim" })
  use({ "tjdevries/colorbuddy.nvim" })
  use({ "AlexvZyl/nordic.nvim" })

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
  use({ "nvim-telescope/telescope-ui-select.nvim" })
  use({ "nvim-telescope/telescope-file-browser.nvim" })
  use({ "ThePrimeagen/harpoon" })

  use({ "rcarriga/nvim-notify" })

  -- Testing
  use({ "vim-test/vim-test" })
  use({
    "nvim-neotest/neotest",
    requires = {
      "antoinemadec/FixCursorHold.nvim",
      "jfpedroza/neotest-elixir",
    },
  })

  use({ "lewis6991/impatient.nvim" })
end)

require("plugins.telescope")
require("plugins.lsp")
