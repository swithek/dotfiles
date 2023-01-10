-----------------------------
--
-- UI Options and Bindings
--
-----------------------------

-- Hide the mode indicator (the statusline contains this information).
vim.opt.showmode = false

-- Make the cursor's shape static.
vim.opt.guicursor = ""

-- Disable mouse support.
vim.opt.mouse = nil

-- Show line numbers.
vim.opt.number = true

-- Activate the list mode (show hidden characters).
vim.opt.list = true

-- Display tabs and leading/trailing spaces as visible characters.
vim.opt.listchars = {
	tab = "|·",
	lead = "~",
	trail = "<",
}

-- Update the method that should be used when creating fold marks.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Highlight the line of the cursor.
vim.opt.cursorline = true

-- Show the recommended line length.
vim.opt.colorcolumn = "79"

-- Extend regular expressions.
vim.opt.magic = true

-- Do not wrap any lines.
vim.opt.wrap = false

-- The minimum number of lines to keep above/below the cursor.
vim.opt.scrolloff = 15

-- Show the matching bracket when a new one is inserted.
vim.opt.showmatch = true

-- Make searches case-insensitive.
vim.opt.ignorecase = true

-- Ignore 'ignorecase' option if the search pattern contains upper case
-- characters.
vim.opt.smartcase = true

-- Apply substitutions on all lines.
vim.opt.gdefault = true

-- toggle_lights changes the colour mode (dark/light) of all visual
-- components of the editor.
local function toggle_lights()
	local initial = vim.fn.empty(vim.g.colors_name) > 0

	if vim.opt.background:get() == "dark" and not initial then
		vim.opt.background = "light"
	else
		vim.opt.background = "dark"
	end

	vim.cmd("colorscheme gruvbox")
end

if vim.fn.empty(vim.g.colors_name) > 0 then
	toggle_lights() -- enable the default (dark) mode
end

-- Create a command to toggle between dark/light colour modes.
vim.api.nvim_create_user_command("ToggleLights", toggle_lights, {})

-- Toggle between dark/light colour modes.
vim.keymap.set("n", "<Leader>m", toggle_lights)

-- use_tabs updates tab-related options.
local function use_tabs(spaces, size)
	if size == 0 then
		size = 8
	end

	vim.opt.expandtab = spaces
	vim.opt.tabstop = size
	vim.opt.shiftwidth = size
	vim.opt.softtabstop = size
end

use_tabs(false, 8) -- enable tabs

-- Create a command to update tab indentation options.
vim.api.nvim_create_user_command("UseTabs",
	function(inp)
		use_tabs(false, tonumber(inp.args))
	end,
	{ nargs = 1 }
)

-- Create a command to update space indentation options.
vim.api.nvim_create_user_command("UseSpaces",
	function(inp)
		use_tabs(true, tonumber(inp.args))
	end,
	{ nargs = 1 }
)

-- Update diagnostic information options.
vim.diagnostic.config {
	virtual_text = {
		prefix = "<-",
	},
	signs = false,
	float = {
		border = "rounded",
	},
}

-- Go to the previous piece of diagnostic information in the current
-- buffer.
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)

-- Go to the next piece of diagnostic information in the current
-- buffer.
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

-- Show all pieces of diagnostic information in the quickfix list.
vim.keymap.set("n", "<Leader>da", vim.diagnostic.setqflist)

-- Show the current buffer's diagnostic information in the quickfix list.
vim.keymap.set("n", "<Leader>d", vim.diagnostic.setloclist)

-- Show diagnostic information in a floating window.
vim.keymap.set("n", "<Space>e", vim.diagnostic.open_float)

-- Toggle between visible and hidden diagnostic information.
local diagnostics_active = true
vim.keymap.set("n", "<Leader>dq", function()
	if diagnostics_active then
		vim.diagnostic.hide()
	else
		vim.diagnostic.show()
	end

	diagnostics_active = not diagnostics_active
end)
