return { 
	'nvim-mini/mini.files', 
	version = '*',
	config = function()
		require("mini.files").setup()
		vim.keymap.set("n", '<leader>-', function()
			MiniFiles.open()
		end
	, {desc = 'open mini.nvim explorer'})
	end
}
