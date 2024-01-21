-------------------------------
--
-- Environment Configuration
--
-------------------------------

-------------------
-- nvim-lspconfig
-------------------

local lsp_config = require("lsp_config")

require("lspconfig").gopls.setup {
	on_attach = lsp_config.on_attach,
	capabilities = lsp_config.capabilities,
}

require("lspconfig").vuels.setup {
	on_attach = lsp_config.on_attach,
	capabilities = lsp_config.capabilities,
	init_options = {
		config = {
			vetur = {
				validation = {
					script = false,
					interpolation = false,
				},
			},
		},
	},
}

require("lspconfig").tsserver.setup {
	on_attach = lsp_config.on_attach,
	capabilities = lsp_config.capabilities,
}

-------------------
-- vim-go
-------------------

-- Disable code completion (another plugin handles this).
vim.g.go_code_completion_enabled = 0

-- Show the name of each failed test.
vim.g.go_test_show_name = 1

-- Set test timeout.
vim.g.go_test_timeout = "20s"

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
