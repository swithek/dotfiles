--------------------------
--
-- Plugins
--
--------------------------

-------------------
-- vim-plug
-------------------

local plug_install_dir = vim.fn.stdpath("data").."/site"
if vim.fn.empty(vim.fn.glob(plug_install_dir.."/autoload/plug.vim")) > 0 then
	vim.fn.system({"curl", "-fLo", plug_install_dir.."/autoload/plug.vim", "--create-dirs", "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"})
	vim.api.nvim_create_autocmd({"VimEnter"}, {
		command = "PlugInstall --sync | source $MYVIMRC",
	})
end

-- Update/install plugins.
vim.keymap.set("n", "<Leader>`", ":PlugUpdate<CR>")

-------------------
-- Installation
-------------------

vim.call("plug#begin")

local plug = vim.fn["plug#"]

plug("williamboman/mason.nvim")           -- LSP/linter/DAP package manager
plug("williamboman/mason-lspconfig.nvim") -- mason and LSP bridge
plug("neovim/nvim-lspconfig")             -- LSP configurations
plug("hrsh7th/nvim-cmp")                  -- autocompletion
plug("hrsh7th/cmp-nvim-lsp")              -- LSP source for cmp
plug("L3MON4D3/LuaSnip")                  -- snippets
plug("saadparwaiz1/cmp_luasnip")          -- snippet source for cmp
plug("ray-x/lsp_signature.nvim")          -- LSP signature hints
plug('nvim-treesitter/nvim-treesitter', { -- syntax parsing and highlighting
	["do"] = ":TSUpdate",
})
plug("nvim-treesitter/nvim-treesitter-context") -- location context info
plug("preservim/nerdtree")                      -- file explorer
plug("ellisonleao/gruvbox.nvim")                -- colour scheme
plug("nvim-lualine/lualine.nvim")               -- statusline
plug("folke/zen-mode.nvim")                     -- distraction-free writing
plug("folke/twilight.nvim")                     -- inactive text dimmer
plug("lukas-reineke/indent-blankline.nvim")     -- space indentation markers
plug("preservim/nerdcommenter")                 -- quick commenting

local env_info = require("env").plug()

vim.call("plug#end")

-------------------
-- mason
-------------------

require("mason").setup {
	ui = {
		border = "rounded",
	},
}

-------------------
-- mason-lspconfig
-------------------

-- available LSP servers:
--  https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--  https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local lsp_servers = { -- core servers
	"lua_ls",
}

for _, val in pairs(env_info) do
	local extras = val.lsp_servers

	for j = 1, #extras do
		if not vim.tbl_contains(lsp_servers, extras[j]) then
			table.insert(lsp_servers, extras[j])
		end
	end
end

require("mason-lspconfig").setup {
	ensure_installed = lsp_servers,
	automatic_installation = true,
}

-------------------
-- nvim-lspconfig
-------------------

local lsp_config = require("lsp_config")

-- on_lsp_attach updates the environment after a successful attachment
-- of a language server.
lsp_config.on_attach = function(_, bufnr)
	local opts = {
		buffer = bufnr,
	}

	-- Jump to definition.
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

	-- Rename all references to a symbol.
	vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, opts)

	-- Show what interfaces are implemented by a type.
	vim.keymap.set("n", "<Leader>w", vim.lsp.buf.implementation, opts)

	-- Show all use places of a symbol.
	vim.keymap.set("n", "<Leader>f", vim.lsp.buf.references, opts)

	-- Show a symbol's information.
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
end

-- Set up Lua's LSP server.
require("lspconfig").lua_ls.setup {
	on_attach = lsp_config.on_attach,
	capabilities = lsp_config.capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = {
					"vim",
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
}

-- Override the default hover handler.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	vim.lsp.handlers.hover, {
		border = "rounded",
	}
)

-------------------
-- nvim-cmp
-------------------

local cmp = require("cmp")
cmp.setup {
	mapping = cmp.mapping.preset.insert {
		["<C-d>"] = cmp.mapping.scroll_docs(-1),
		["<C-f>"] = cmp.mapping.scroll_docs(1),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-q>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping.confirm({ select = true }),
	},
	window = {
		documentation = cmp.config.window.bordered {
			winhighlight = "Search:None",
		},
		completion = cmp.config.window.bordered {
			winhighlight = "Search:None",
		},
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	sources = cmp.config.sources {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
}

-------------------
-- cmp-nvim-lsp
-------------------

lsp_config.capabilities = require("cmp_nvim_lsp").update_capabilities(
	vim.lsp.protocol.make_client_capabilities()
)

-------------------
-- lsp_signature
-------------------

require("lsp_signature").setup {
	hint_enable = false,
}

-------------------
-- nvim-treesitter
-------------------

-- available treesiter languages: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
local treesitter_langs = { -- core languages
	"comment",
	"gitignore",
	"json",
	"lua",
	"make",
	"markdown",
	"toml",
	"vim",
	"yaml",
}

for _, val in pairs(env_info) do
	local extras = val.treesitter_langs

	for j = 1, #extras do
		if not vim.tbl_contains(treesitter_langs, extras[j]) then
			table.insert(treesitter_langs, extras[j])
		end
	end
end

require("nvim-treesitter.configs").setup {
	ensure_installed = treesitter_langs,
	auto_install = true,
	highlight = {
		enable = true,
	},
}

---------------------------
-- nvim-treesitter-context
---------------------------

require("treesitter-context").setup()

-------------------
-- nerdtree
-------------------

-- Open file explorer on enter.
vim.api.nvim_create_autocmd({"VimEnter"}, {
	command = "NERDTree",
})

-- Open/close the file explorer.
vim.keymap.set("n", "<Leader>o", ":NERDTreeToggle<CR>", {
	silent = true,
})

-------------------
-- gruvbox
-------------------

require("gruvbox").setup {
	italic = false,
	contrast = "hard",
	overrides = {
		SignColumn = { bg = "NONE" },
		GruvboxRedSign = { bg = "NONE" },
		GruvboxGreenSign = { bg = "NONE" },
		GruvboxYellowSign = { bg = "NONE" },
		GruvboxBlueSign = { bg = "NONE" },
		GruvboxPurpleSign = { bg = "NONE" },
		GruvboxAquaSign = { bg = "NONE" },
		GruvboxOrangeSign = { bg = "NONE" },
		NormalFloat = { bg = "NONE" },
	},
}

-------------------
-- lualine
-------------------

require("lualine").setup()

-------------------
-- zen-mode
-------------------

local zen_mode = require("zen-mode")

zen_mode.setup {
	window = {
		backdrop = 1,
		width = 80,
		options = {
			signcolumn = "no",
			number = false,
			cursorline = false,
			list = false,
			colorcolumn = "",
		},
	},
}

-- Toggle the focus mode.
vim.keymap.set("n", "<Leader>z", zen_mode.toggle)

-------------------
-- twilight
-------------------

require("twilight").setup()

-- Toggle twilight status.
vim.keymap.set("n", "<Leader>x", ":Twilight<CR>", {
	silent = true,
})

-------------------
-- indent-blankline
-------------------

require("indent_blankline").setup {
	use_treesitter = true,
}
