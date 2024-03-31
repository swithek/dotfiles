--------------------------
--
-- Plugin Installation
--
--------------------------

local plug = vim.fn["plug#"]

plug("fatih/vim-go", {
	["do"] = ":GoUpdateBinaries",
	["for"] = "go",
})
plug("prettier/vim-prettier", {
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
plug("nvim-lua/plenary.nvim") -- used by typescript-tools
plug("pmizio/typescript-tools.nvim")

return {
	treesitter_langs = {
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
	},
	lsp_servers = {
		"gopls",    -- go
		"volar",    -- vue
	},
	lsp_handlers = {},
}
