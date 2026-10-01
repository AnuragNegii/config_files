return{
	{
	"mason-org/mason.nvim",
	config = function()
		require("mason").setup()
	end
},
{
	 "mason-org/mason-lspconfig.nvim",
		config = function()
		 require("mason-lspconfig").setup({
			 ensure_installed = {"lua_ls", "vimls", "pyright", "qmlls"}
		 })
	 end
},
{
    "neovim/nvim-lspconfig",
		config = function()
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			vim.lsp.config("lua_ls", {capabilities = capabilities})
			vim.lsp.config("vimls", {capabilities = capabilities})
			vim.lsp.config("pyright", { capabilities = capabilities, })
			vim.lsp.config("qmlls", { capabilities = capabilities, })

			vim.lsp.enable("vimls")
			vim.lsp.enable("qmlls")
			vim.lsp.enable("pyright")
			vim.lsp.enable("lua_ls")
			vim.keymap.set("n", 'K', vim.lsp.buf.hover, {})
			vim.keymap.set("n", 'gD', vim.lsp.buf.definition, {})
			vim.keymap.set({"n", 'v'}, '<leader>ca',vim.lsp.buf.code_action, {})
		end
	}
}
