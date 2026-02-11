--------------------------
--
-- Plugins
--
--------------------------

local lsp_config = {
	on_attach = nil,
	capabilities = nil,
}

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

plug("williamboman/mason.nvim")           -- LSP/linter package manager
plug("williamboman/mason-lspconfig.nvim") -- mason and LSP bridge
plug("neovim/nvim-lspconfig")             -- LSP configurations
plug("hrsh7th/nvim-cmp")                  -- autocompletion
plug("hrsh7th/cmp-nvim-lsp")              -- LSP source for cmp
plug("ray-x/lsp_signature.nvim")          -- LSP signature hints
plug('nvim-treesitter/nvim-treesitter', { -- syntax parsing and highlighting
	["do"] = ":TSUpdate",
})
plug("nvim-treesitter/nvim-treesitter-context") -- location context info
plug("preservim/nerdtree")                      -- file explorer
plug("catppuccin/nvim", {                       -- colour scheme
	["as"] = "catppuccin",
})
plug("nvim-lualine/lualine.nvim")               -- statusline
plug("folke/zen-mode.nvim")                     -- distraction-free writing
plug("folke/twilight.nvim")                     -- inactive text dimmer
plug("lukas-reineke/indent-blankline.nvim")     -- space indentation markers
plug("preservim/nerdcommenter")                 -- quick commenting
plug("fatih/vim-go", {                          -- go tools and other extras
	["do"] = ":GoUpdateBinaries",
	["for"] = "go",
})
plug("prettier/vim-prettier", {                 -- formatting
	["do"] = "npm install",
	["for"] = {
		"javascript",
		"typescript",
		"css",
		"scss",
		"vue",
		"html",
		"json",
		"yaml",
		"toml",
		"markdown",
	},
})

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
local lsp_servers = {
	"lua_ls", -- lua
	"gopls",  -- go
	"volar",  -- vue
	"astro",  -- astro
	"mdx_analyzer", -- mdx
}

require("mason-lspconfig").setup {
	ensure_installed = lsp_servers,
	automatic_installation = true,
}

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
	sources = cmp.config.sources {
		{ name = "nvim_lsp" },
	},
}

-------------------
-- cmp-nvim-lsp
-------------------

lsp_config.capabilities = require("cmp_nvim_lsp").default_capabilities(
	vim.lsp.protocol.make_client_capabilities()
)

-------------------
-- nvim-lspconfig
-------------------

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

-- Override the default hover handler.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	vim.lsp.handlers.hover, {
		border = "rounded",
	}
)

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

-- Set up Go's LSP server.
require('lspconfig').gopls.setup({
	on_attach = lsp_config.on_attach,
	capabilities = lsp_config.capabilities,
})

-- Set up Vue's LSP server.
require('lspconfig').volar.setup({
	on_attach = lsp_config.on_attach,
	capabilities = lsp_config.capabilities,
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	init_options = {
		vue = {
			hybridMode = false,
		},
	},
})

-- Set up Astro's LSP server.
require('lspconfig').astro.setup({
	on_attach = lsp_config.on_attach,
	capabilities = lsp_config.capabilities,
})

-- Set up MDX's LSP server.
require('lspconfig').mdx_analyzer.setup({
	on_attach = lsp_config.on_attach,
	capabilities = lsp_config.capabilities,
})

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
local treesitter_langs = {
	"comment",
	"gitignore",
	"json",
	"lua",
	"make",
	"markdown",
	"toml",
	"vim",
	"yaml",
	"bash",
	"c",
	"css",
	"dockerfile",
	"go",
	"gomod",
	"gowork",
	"hcl",
	"html",
	"javascript",
	"python",
	"regex",
	"rust",
	"scss",
	"solidity",
	"sql",
	"typescript",
	"vue",
	"astro",
}

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
-- catppuccin
-------------------

require("catppuccin").setup {
	flavour = "mocha",
	integrations = {
		mason = true,
		indent_blankline = {
			enabled = true,
			scope_color = "",
			colored_indent_levels = false,
		},
    	},
}

-------------------
-- lualine
-------------------

require("lualine").setup {
	options = {
		theme = "catppuccin",
	},
}

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

require("ibl").setup()

-------------------
-- vim-go
-------------------

-- Disable code completion (another plugin handles this).
vim.g.go_code_completion_enabled = 0

-- Show the name of each failed test.
vim.g.go_test_show_name = 1

-- Set test timeout.
vim.g.go_test_timeout = "1m"

-- Do not jump to the first error when building/testing, etc.
vim.g.go_jump_to_error = 0

-- Disable the default bindings for GoDef operations (another plugin
-- handles this).
vim.g.go_def_mapping_enabled = 0

-- Disable custom text objects (another plugin provides this functionality).
vim.g.go_textobj_enabled = 0

-- Prevent vim-go from using gopls (other plugins use gopls and provide
-- similar functionality).
vim.g.go_gopls_enabled = 0

-- Add only a package name when creating a new go file.
vim.g.go_template_use_pkg = 1

-- Do not add tags to unexported fields.
vim.g.go_addtags_skip_unexported = 1

vim.api.nvim_create_autocmd({"FileType"}, {
	group = vim.api.nvim_create_augroup("go_bindings", {}),
	pattern = "go",
	callback = function ()
		local opts = {
			buffer = true,
			silent = true,
		}

		-- Run all tests of a package.
		vim.keymap.set("n", "<Leader>tt", "<Plug>(go-test)", opts)

		-- Run only the test that is under the cursor.
		vim.keymap.set("n", "<Leader>tf", "<Plug>(go-test-func)", opts)

		-- Toggle between active and inactive code coverage.
		vim.keymap.set("n", "<Leader>k", "<Plug>(go-coverage-toggle)", opts)

		-- Generate an error check.
		vim.keymap.set("n", "<Leader>er", "<Plug>(go-iferr)", opts)

		-- Generate an interface implementation stub.
		vim.keymap.set("n", "<Leader>i", ":GoImpl<CR>", opts)

		-- Go to the alternate (test/non-test) file.
		vim.keymap.set("n", "<Leader>a", "<Plug>(go-alternate-vertical)", opts)

		-- Add field tags to a struct.
		vim.keymap.set("n", "<Leader>tg", ":GoAddTags<CR>", opts)

		-- Fill a struct instance with default values.
		vim.keymap.set("n", "<Leader>sf", ":GoFillStruct<CR>", opts)
	end,
})

-------------------
-- vim-prettier
-------------------

-- Enable autoformatting on save.
vim.g["prettier#autoformat"] = 0
vim.g["prettier#autoformat_require_pragma"] = 0
