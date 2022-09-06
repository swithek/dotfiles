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

return {
	treesitter_langs = {
		"bash",
		"c",
		"css",
		"dockerfile",
		"go",
		"gomod",
		"gowork",
		"html",
		"javascript",
		"python",
		"rust",
		"scss",
		"solidity",
		"sql",
		"typescript",
		"vue",
	},
	lsp_servers = {
		"gopls",
	},
}
