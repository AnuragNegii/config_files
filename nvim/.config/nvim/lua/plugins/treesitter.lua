return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",

		config = function()
			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			require("nvim-treesitter").install({
				"rust",
				"javascript",
				"zig",
				"python",
				"qmljs",
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "rust", "javascript", "zig", "python", "qmljs"},
				callback = function()
					vim.treesitter.start()
				end,
			})
		end,
	},
}
