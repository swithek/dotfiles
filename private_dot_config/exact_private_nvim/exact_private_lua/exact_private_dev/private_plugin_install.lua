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
})

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
		"vuels",    -- vue: replace with volar when it stops crashing
		"tsserver", -- typescript
	},
}
