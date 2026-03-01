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

vim.diagnostic.config({
	-- I like it showing up in line compared to as text IG
	-- virtual_text = true,
	virtual_lines = true,
	underline = true,
})

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
			-- Copy pasted from kickstart nvim, I dont understand how to setup the LSP properyly, and right now I dont feel like spending that time
			-- TODO: spend sometime understanding this config, basically I want to be able to trim this config somewhat
			-- and learn the lsp behaviours I could use right now kinda depend on the snacks lsp keymaps, want to build my own understanding what are available what needs to be depend on snacks for
			-- Main LSP Configuration
			'neovim/nvim-lspconfig',
			dependencies = {
				-- Automatically install LSPs and related tools to stdpath for Neovim
				-- Mason must be loaded before its dependents so we need to set it up here.
				-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
				{
					'mason-org/mason.nvim',
					---@module 'mason.settings'
					---@type MasonSettings
					---@diagnostic disable-next-line: missing-fields
					opts = {},
				},
				-- Maps LSP server names between nvim-lspconfig and Mason package names.
				'mason-org/mason-lspconfig.nvim',
				'WhoIsSethDaniel/mason-tool-installer.nvim',

				-- Useful status updates for LSP.
				{ 'j-hui/fidget.nvim', opts = {} },

				-- Allows extra capabilities provided by blink.cmp
				'saghen/blink.cmp',
			},
			config = function()
				-- Brief aside: **What is LSP?**
				--
				-- LSP is an initialism you've probably heard, but might not understand what it is.
				--
				-- LSP stands for Language Server Protocol. It's a protocol that helps editors
				-- and language tooling communicate in a standardized fashion.
				--
				-- In general, you have a "server" which is some tool built to understand a particular
				-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
				-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
				-- processes that communicate with some "client" - in this case, Neovim!
				--
				-- LSP provides Neovim with features like:
				--  - Go to definition
				--  - Find references
				--  - Autocompletion
				--  - Symbol Search
				--  - and more!
				--
				-- Thus, Language Servers are external tools that must be installed separately from
				-- Neovim. This is where `mason` and related plugins come into play.
				--
				-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
				-- and elegantly composed help section, `:help lsp-vs-treesitter`

				--  This function gets run when an LSP attaches to a particular buffer.
				--    That is to say, every time a new file is opened that is associated with
				--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
				--    function will be executed to configure the current buffer
				--
				--    self notes from here to understand lsp, reddit doesnt seem much helpful here, want to setup lsp and completion with least effort
				--    creating LspAttach autocommands
				vim.api.nvim_create_autocmd('LspAttach', {
					group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
					callback = function(event)
						-- NOTE: Remember that Lua is a real programming language, and as such it is possible
						-- to define small helper and utility functions so you don't have to repeat yourself.
						--
						-- In this case, we create a function that lets us more easily define mappings specific
						-- for LSP related items. It sets the mode, buffer and description for us each time.
						local map = function(keys, func, desc, mode)
							mode = mode or 'n'
							vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
						end

						-- Rename the variable under your cursor.
						--  Most Language Servers support renaming across files, etc.
						map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

						-- Execute a code action, usually your cursor needs to be on top of an error
						-- or a suggestion from your LSP for this to activate.
						map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

						-- WARN: This is not Goto Definition, this is Goto Declaration.
						--  For example, in C this would take you to the header.
						map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

						-- The following two autocommands are used to highlight references of the
						-- word under your cursor when your cursor rests there for a little while.
						--    See `:help CursorHold` for information about when this is executed
						--
						-- When you move your cursor, the highlights will be cleared (the second autocommand).
						local client = vim.lsp.get_client_by_id(event.data.client_id)
						if client and client:supports_method('textDocument/documentHighlight', event.buf) then
							local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
							vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.document_highlight,
							})

							vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.clear_references,
							})

							vim.api.nvim_create_autocmd('LspDetach', {
								group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
								callback = function(event2)
									vim.lsp.buf.clear_references()
									vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
								end,
							})
						end

						-- The following code creates a keymap to toggle inlay hints in your
						-- code, if the language server you are using supports them
						--
						-- This may be unwanted, since they displace some of your code
						if client and client:supports_method('textDocument/inlayHint', event.buf) then
							map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
						end
					end,
				})

				-- Enable the following language servers
				--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
				--  See `:help lsp-config` for information about keys and how to configure
				---@type table<string, vim.lsp.Config>
				local servers = {
					clangd = {},
					gopls = {},
					pyright = {},
					rust_analyzer = {},
					bashls = {},
					--
					-- Some languages (like typescript) have entire language plugins that can be useful:
					--    https://github.com/pmizio/typescript-tools.nvim
					--
					-- But for many setups, the LSP (`ts_ls`) will work just fine
					-- ts_ls = {},

					stylua = {}, -- Used to format Lua code

					-- Special Lua Config, as recommended by neovim help docs
					lua_ls = {
						on_init = function(client)
							if client.workspace_folders then
								local path = client.workspace_folders[1].name
								if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
							end

							client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
								runtime = {
									version = 'LuaJIT',
									path = { 'lua/?.lua', 'lua/?/init.lua' },
								},
								workspace = {
									checkThirdParty = false,
									-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
									--  See https://github.com/neovim/nvim-lspconfig/issues/3189
									library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
										'${3rd}/luv/library',
										'${3rd}/busted/library',
									}),
								},
							})
						end,
						settings = {
							Lua = {},
						},
					},
				}

				-- Ensure the servers and tools above are installed
				--
				-- To check the current status of installed tools and/or manually install
				-- other tools, you can run
				--    :Mason
				--
				-- You can press `g?` for help in this menu.
				local ensure_installed = vim.tbl_keys(servers or {})
				vim.list_extend(ensure_installed, {
					-- You can add other tools here that you want Mason to install
				})

				require('mason-tool-installer').setup { ensure_installed = ensure_installed }

				for name, server in pairs(servers) do
					vim.lsp.config(name, server)
					vim.lsp.enable(name)
				end

				-- since mason is already install/loaded IG I can use this here to configure how the diagnostic should show up

			end,
		}, {
			'saghen/blink.cmp',
			-- optional: provides snippets for the snippet source
			dependencies = { 'rafamadriz/friendly-snippets' },

			-- use a release tag to download pre-built binaries, not sure if I want to use this, dont wanna be on nightly
			version = '1.*',
			-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
			-- build = 'cargo build --release',
			-- If you use nix, you can build from source using latest nightly rust with:
			-- build = 'nix run .#build-plugin',

			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
				-- 'super-tab' for mappings similar to vscode (tab to accept)
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- All presets have the following mappings:
				-- C-space: Open menu or open docs if already open
				-- C-n/C-p or Up/Down: Select next/previous item
				-- C-e: Hide menu
				-- C-k: Toggle signature help (if signature.enabled = true)
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				keymap = { preset = 'default' },

				appearance = {
					-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = 'mono'
				},

				-- (Default) Only show the documentation popup when manually triggered
				completion = { documentation = { auto_show = false } },

				-- Default list of enabled providers defined so that you can extend it
				-- elsewhere in your config, without redefining it, due to `opts_extend`
				sources = {
					default = { 'lsp', 'path', 'snippets', 'buffer' },
				},

				-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
				-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
				-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
				--
				-- See the fuzzy documentation for more information
				fuzzy = { implementation = "prefer_rust_with_warning" }
			},
			opts_extend = { "sources.default" }
		},{
			"folke/snacks.nvim",
			dependencies = { "folke/todo-comments.nvim" },
			priority = 1000,
			lazy = false,
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
								["<c-h>"] = { "preview_scroll_right", mode = { "n", "i" } },
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

				-- need to setup LSP to figure out if they are useful, I think they can be setup without snacks, wonder why his is being set here
				-- TODO: I dont wanna depend on snacks interface for this, lets do it without snacks
				{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
				{ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
				{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
				{ "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
				{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
				{ "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
				{ "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
				{ "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
				{ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

				-- depends on todo_comments, not sure why is throwing warning here
				{ "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },

			},
			config = function(_, opts)
				require("snacks").setup(opts)
			end
		},{
			-- LOOK: currently in gutter there seems to be only one possible synbol, see if its possible to keep 2 symbols or more side by side and have max gutter size
			"folke/todo-comments.nvim",
			-- I think the enabled flag is present for cases where you dont wanna install the plugin seperately if its already being pulled from other plugin IG, maybe this is not required here
			-- enabled = true,
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				keywords = {
					FIX = {
						icon = " ", -- icon used for the sign, and in search results
						color = "error", -- can be a hex color, or a named color (see below)
						alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
						-- signs = false, -- configure signs for some keywords individually
						-- :
					},
					TODO = { icon = " ", color = "info" },
					HACK = { icon = " ", color = "warning" },
					WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
					PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
					NOTE = { icon = " ", color = "hint", alt = { "INFO", "LOOK" } },
					TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
				},
			},
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

						local function map(mode, l, r, opt)
							opt = opt or {}
							opt.buffer = bufnr
							vim.keymap.set(mode, l, r, opt)
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
						end, {desc = "show git blame line"})

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
