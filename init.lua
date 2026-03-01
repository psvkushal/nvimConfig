-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- [[ Setting options ]] See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:help option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)

-- Print the line number in front of each line
vim.o.number = true

-- Use relative line numbers, so that it is easier to jump with j, k. This will affect the 'number'
-- option above, see `:h number_relativenumber`
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
	callback = function()
		vim.o.clipboard = 'unnamedplus'
	end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Highlight the line where the cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Show <tab> and trailing spaces
vim.o.list = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s) See `:help 'confirm'`
vim.o.confirm = true

-- I like this one among the defaults
-- vim.cmd("colorscheme retrobox")

-- [[ Set up keymaps ]] See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
-- vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
-- vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
-- vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
-- vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
-- vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
-- vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
-- vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
-- vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
-- vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- [[ Basic Autocommands ]].
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	callback = function()
		vim.hl.on_yank()
	end,
})


-- [[ Create user commands ]]
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
	local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
	local filename = vim.api.nvim_buf_get_name(0)
	print(vim.fn.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }))
end, { desc = 'Print the git blame for the current line' })

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{
			-- I think I should just use retrobox for sometime and see what difference does that make
			"ellisonleao/gruvbox.nvim",
			priority = 1000,
			opts = {
				terminal_colors = true, -- add neovim terminal colors
				undercurl = true,
				underline = true,
				bold = true,
				italic = {
					strings = true,
					emphasis = true,
					comments = true,
					operators = false,
					folds = true,
				},
				strikethrough = true,
				invert_selection = false,
				invert_signs = false,
				invert_tabline = false,
				inverse = true, -- invert background for search, diffs, statuslines and errors
				contrast = "", -- can be "hard", "soft" or empty string
				palette_overrides = {
					-- Okay if I want to feel like darker gruv lets use this options thanks claude
					-- hard dark bg is normally #1d2021, go even darker:
					-- dark0_hard = "#0d1010",   -- main background
					-- dark0      = "#0d1010",   -- used in some places too
					-- dark0_soft = "#181818",   -- softer variant

					-- -- you can also darken the "panels" background (statusline, sidebar, etc.):
					-- dark1 = "#1a1a1a",        -- normally #3c3836
				},
				overrides = {},
				dim_inactive = false,
				transparent_mode = false,
			},
			config = function(_, opts)
				require("gruvbox").setup(opts)
				vim.cmd("colorscheme gruvbox")
			end,

		}, {
			-- I like the suggestion it gives, there are alternatives like hydra.nvim etc lets try it in next run, although itseems there is hydra mode maybe check that out 
			"folke/which-key.nvim",
			-- there might be additional settings might be required
		},{
			"folke/snacks.nvim",
			opts = {
				image = {},
				picker = {
					win = {
						preview = {
							wo = {
								wrap = false, -- hoping this would work but was not working
							},
						},
						input = {
							keys = {
								["<c-k>"] = { "preview_scroll_up", mode = { "n", "i" } },
								["<c-j>"] = { "preview_scroll_down", mode = { "n", "i" } },
								-- if wrapping was there the below would have been useful for now IG lets ignore these
								["<c-l>"] = { "preview_scroll_left", mode = { "n", "i" } },
								["<c-h>"] = { "preview_scroll_righ", mode = { "n", "i" } },
							},
						},
					},
				},
				explorer = {},
			},
			keys = {
				-- shortcuts which I like or excited and useful
				{ "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
				{ "<leader>sr", function() Snacks.picker.recent() end, desc = "Recent" }, -- yeah this is cool
				{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } }, -- its between yeah this is useful in the sense like I like the preview I get, but I think doing it nvim default way might be better
				{ '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" }, -- interesting not sure if useful
				{ '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" }, -- interesting can include in workflow instead of using up or down key
				{ "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" }, -- not used autocmd much, maybe I can understand and see if they can be included
				{ "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" }, -- yeah dont use cmds much, commands which I use most are converted into shortcuts so not sure how useful this will be but lets see
				{ "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" }, -- same as above, but I think this might be mroe useful
				{ "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" }, -- okay not sure what is highlights maybe look into this, I think this one can be made redundant for now by using search commands and using that command, this feels like something I rarely use
				{ "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" }, -- okay this is what I wanted to do for long time and itseems to be already present 😺 yeah this is good
				{ "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" }, -- yeah searching for keymaps is good, incase I forgot just for this scenario, I dont wanna be sarcastic here🤷‍♀️
				{ "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
				{ "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
				{ "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
				{ "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" }, -- the above 2 I need to understand before I can fully leverage them IG
				{ "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" }, -- not sure what it does -- okay this might be powerful going back to specifc thing yeah thats crazy 

				-- already use it so its useful no new emtion
				{ "<leader><space>", function() Snacks.picker.buffers() end, desc = "Buffers" },
				{ "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
				{ "<leader>sf", function() Snacks.picker.files() end, desc = "Find Files" },
				{ "<leader>sG", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" }, --  not exactly used but need to look for different command
				{ "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
				{ "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
				
				-- shortcuts not so sure might be useful
				{ "<leader>sF", function() Snacks.picker.smart() end, desc = "Smart Find Files" }, -- its like do I need entire global search sometimes useful
				{ "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" }, -- I am not sure what the notification maybe if llm is integrated might be useful?
				{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" }, --- its good to just open and read this but like really needed not sure?
				{ "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" }, -- mostly will delete it, will keep it for now, if there is other command which needs this shortcut then will remove this
				{ "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" }, -- yeah interesting but eeehh is it useful for me right now?
				{ "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" }, -- already have git not so sure
				{ "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
				{ "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
				{ "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
				{ "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
				{ "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" }, -- already have it from git signs, but the way I can move to other things is interesting, IG I can avoid quickfixlist and use this, but if in quickfixlist I can keep moving between buffers then that would be more cool than this one
				{ "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
				{ "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
				{ "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
				{ "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" }, -- going through colorscheme in command line seems better, but IG this one switches the color scheme faster, so maybe useful?

				-- there should be a vim or nvim default way of doing this instead of using this one
				{ "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" }, -- oil might be better here I feel
				{ "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
				{ "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },

				-- need to setup LSP to figure out if they are useful
				{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
				{ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
				{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
				{ "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
				{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
				{ "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
				{ "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
				{ "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
				{ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

			},
			config = function(_, opts)
				require("snacks").setup(opts)
			end
		},{
				"lewis6991/gitsigns.nvim",
				opts = {
					signs = {
						add          = { text = '+' },
						change       = { text = '┃' },
						delete       = { text = '_' },
						topdelete    = { text = '‾' },
						changedelete = { text = '~' },
						untracked    = { text = '┆' },
					},
					signs_staged = {
						add          = { text = '+' },
						change       = { text = '┃' },
						delete       = { text = '_' },
						topdelete    = { text = '‾' },
						changedelete = { text = '~' },
						untracked    = { text = '┆' },
					},
					signs_staged_enable = true,
					signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
					numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
					linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
					word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
					watch_gitdir = {
						follow_files = true
					},
					auto_attach = true,
					attach_to_untracked = false,
					current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
					current_line_blame_opts = {
						virt_text = true,
						virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
						delay = 1000,
						ignore_whitespace = false,
						virt_text_priority = 100,
						use_focus = true,
					},
					current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
					sign_priority = 6,
					update_debounce = 100,
					status_formatter = nil, -- Use default
					max_file_length = 40000, -- Disable if file is longer than this (in lines)
					preview_config = {
						-- Options passed to nvim_open_win
						style = 'minimal',
						relative = 'cursor',
						row = 0,
						col = 1
					},
				},
				config = function(_, opts)
					opts.on_attach = function(bufnr)
						local gitsigns = require('gitsigns')

						local function map(mode, l, r, opts)
							opts = opts or {}
							opts.buffer = bufnr
							vim.keymap.set(mode, l, r, opts)
						end

						-- Navigation
						map('n', ']c', function()
							if vim.wo.diff then
								vim.cmd.normal({']c', bang = true})
							else
								gitsigns.nav_hunk('next')
							end
						end, {desc = "move to next hunk in buffer"})

						map('n', '[c', function()
							if vim.wo.diff then
								vim.cmd.normal({'[c', bang = true})
							else
								gitsigns.nav_hunk('prev')
							end
						end, {desc = "move to prev hunk in buffer"})

						-- Actions
						map('n', '<leader>hs', gitsigns.stage_hunk, {desc = "toggle hunk staging"})
						map('n', '<leader>hr', gitsigns.reset_hunk, {desc = "reset hunk"})

						map('v', '<leader>hs', function()
							gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
						end, {desc = "stage selected hunk part"})

						map('v', '<leader>hr', function()
							gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
						end, {desc = "reset selected hunk part"})

						map('n', '<leader>hS', gitsigns.stage_buffer, {desc = "stage buffer"})
						map('n', '<leader>hR', gitsigns.reset_buffer, {desc = "reset buffer"})
						map('n', '<leader>hp', gitsigns.preview_hunk, {desc = "preview hunk"})
						map('n', '<leader>hi', gitsigns.preview_hunk_inline, {desc = "preview hunk inline"})
						map('n', '<leader>hU', gitsigns.reset_buffer_index, {desc = "unstage buffer"})

						map('n', '<leader>hb', function()
							gitsigns.blame_line({ full = true })
						end, {desc = "git blame line"}, {desc = "show git blame for line"})
						map('n', '<leader>hB', gitsigns.blame, {desc = "show git blame for buffer"})
						-- how is it different than the next one?
						map('n', '<leader>hd', gitsigns.diffthis, {desc = "diff this? "})

						map('n', '<leader>hD', function()
							gitsigns.diffthis('~')
						end, {desc = "diff this?? (ns) I think it diffs only changes IG?"})

						-- go through the docs to understand this
						map('n', '<leader>hQ', function() gitsigns.setqflist('all') end, {desc = "set qflist"})
						map('n', '<leader>hq', gitsigns.setqflist, {desc = "list qflist"})

						-- Toggles
						map('n', '<leader>tb', gitsigns.toggle_current_line_blame, {desc = "toggle git line blame"})
						map('n', '<leader>tw', gitsigns.toggle_word_diff, {desc = "toggle word difff"})

						-- Text object
						map({'o', 'x'}, 'ih', gitsigns.select_hunk, {desc = "select hunk"})
					end
					require('gitsigns').setup(opts)
				end,

			}
		},
	-- if you dont need the below options you can remove the spec and below and just pass the list of plugins
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "retrobox" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
