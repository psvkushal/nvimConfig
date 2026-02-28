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
				palette_overrides = {},
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
			-- https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions go through these extensions and see if you can add something useful here
			-- :h telescope.mappings to look into how to move in the windows of telescope picker and telescope.pickers.layout to arrange the layout of telescope
			'nvim-telescope/telescope.nvim', version = '*',
			dependencies = {
				'nvim-lua/plenary.nvim',
				'nvim-lua/popup.nvim',
				{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
				'nvim-telescope/telescope-media-files.nvim',
			},
			opts = {
				defaults = {
					-- Default configuration for telescope goes here:
					-- config_key = value,
					wrap_results = true,
					mappings = {
						i = {
							-- map actions.which_key to <C-h> (default: <C-/>)
							-- actions.which_key shows the mappings for your picker,
							-- e.g. git_{create, delete, ...}_branch for the git_branches picker
							-- ["<C-h>"] = "which_key"
							-- <c-u> and <c-d> are mapped for moving up and down similar to how you move in buffer but, having mapped c-h and c-l for moving left and right, I am moving everything to the left
							["<C-k>"] = "preview_scrolling_up",
							["<C-j>"] = "preview_scrolling_down",
							["<C-h>"] = "preview_scrolling_left",
							["<C-l>"] = "preview_scrolling_right",
						},
					},
				},
				-- There are pickers and extensions config which is better to add based on whats required, I think I would like to add the image one, to view through the images
				-- currently there seems to be a way to scroll through the results buffer I want to see how it can be done or use different mapping
			},
			config = function(_, opts)
				require('telescope').setup(opts)

				local builtin = require('telescope.builtin')
				vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Telescope find files' })
				vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Telescope live grep' })
				vim.keymap.set('n', '<leader>sr', builtin.resume, {desc = 'Telesceop resume search'})
				vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Telescope buffers' })
				vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Telescope help tags' })
			end,
		},{
			-- sets up image support
			"3rd/image.nvim",
			opts = {
				backend = "kitty", -- or "ueberzug" or "sixel"
				processor = "magick_cli", -- or "magick_rock"
				integrations = {
					markdown = {
						enabled = true,
						clear_in_insert_mode = false,
						download_remote_images = true,
						only_render_image_at_cursor = false,
						only_render_image_at_cursor_mode = "popup", -- or "inline"
						floating_windows = false, -- if true, images will be rendered in floating markdown windows
						filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
					},
					asciidoc = {
						enabled = true,
						clear_in_insert_mode = false,
						download_remote_images = true,
						only_render_image_at_cursor = false,
						only_render_image_at_cursor_mode = "popup",
						floating_windows = false,
						filetypes = { "asciidoc", "adoc" },
					},
					neorg = {
						enabled = true,
						filetypes = { "norg" },
					},
					rst = {
						enabled = true,
					},
					typst = {
						enabled = true,
						filetypes = { "typst" },
					},
					html = {
						enabled = false,
					},
					css = {
						enabled = false,
					},
				},
				max_width = nil,
				max_height = nil,
				max_width_window_percentage = nil,
				max_height_window_percentage = 50,
				scale_factor = 1.0,
				window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
				window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
				editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
				tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
				hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
			},
			config = function(_, opts)
				require('image').setup(opts)
			end

		}
	},
	-- if you dont need the below options you can remove the spec and below and just pass the list of plugins
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "retrobox" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
