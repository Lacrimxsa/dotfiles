return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"debugloop/telescope-undo.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local tele_actions = require("telescope.actions")
		local lga_actions = require("telescope-live-grep-args.actions")
		local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
		local undo_actions = require("telescope-undo.actions")
		local r = require("utils.remaps")
		local borders = {
				dashed = { "┄", "┊", "┄", "┊", "╭", "╮", "╯", "╰",},
        double = { "═", "║", "═", "║", "╔", "╗", "╝", "╚",},
        single = { "─", "│", "─", "│", "╭", "╮", "╯", "╰",},
        blocks = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙",},
        blocky = { "▀", "▐", "▄", "▌", "▄", "▄", "▓", "▀",},
      }
		telescope.setup({
			defaults = {
				layout_config = {
					anchor = "center",
					height = 0.8,
					width = 0.9,
					preview_width = 0.6,
					prompt_position = "bottom",
				},
				borderchars = {
					prompt = borders.dashed,
					results = { "┄", " ", "┄", "┊", "╭", "┄", "┄", "╰",},
					preview = { "┄", "┊", "┄", "┊", "┄", "╮", "╯", "╰",},
				},
				mappings = {
					i = {
						["<esc>"] = tele_actions.close,
					},
				},
			},
			extensions = {
				undo = {
					use_delta = true,
					side_by_side = true,
					entry_format = "󰣜 #$ID, $STAT, $TIME",
					layout_strategy = "flex",
					mappings = {
						i = {
							["<cr>"] = undo_actions.yank_additions,
							["<S-cr>"] = undo_actions.yank_deletions,
							["<C-\\>"] = undo_actions.restore,
						},
					},
				},
				live_grep_args = {
					auto_quoting = true,
					mappings = {
						i = {
							["<C-\\>"] = lga_actions.quote_prompt({ postfix = " --hidden " }),
						},
					},
				},
				file_browser = {
					depth = 1,
					auto_depth = false,
					hidden = { file_browser = true, folder_browser = true },
					hide_parent_dir = false,
					collapse_dirs = false,
					prompt_path = false,
					quiet = false,
					dir_icon = "󰉓 ",
					dir_icon_hl = "Default",
					display_stat = { date = true, size = true, mode = true },
					git_status = true,
				},
			},
		})
		r.noremap("n", "<leader>u", ":Telescope undo<cr>", "undo tree")
		r.noremap("n", "\\", ":Telescope live_grep_args<cr>", "live grep")
		r.noremap("n", "<leader>o", ":Telescope oldfiles<cr>", "old files")
		r.noremap("n", "<leader>gc", function()
			lga_shortcuts.grep_word_under_cursor({ postfix = " --hidden " })
		end, "grep under cursor")
		r.noremap("n", "<leader>f", function()
			telescope.extensions.file_browser.file_browser()
		end, "browse files")
		r.noremap("n", "<leader>.", function()
			telescope.extensions.file_browser.file_browser({
				path = vim.fn.stdpath("config")
			})
		end, "nvim dotfiles")
		telescope.load_extension("undo")
		telescope.load_extension("file_browser")
		telescope.load_extension("live_grep_args")
	end,
}
