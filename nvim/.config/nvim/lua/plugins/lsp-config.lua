return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "vimls",
          "pyright",
          "qmlls",
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
      })

      vim.lsp.config("vimls", {
        capabilities = capabilities,
      })

      vim.lsp.config("pyright", {
        capabilities = capabilities,
      })

      vim.lsp.config("qmlls", {
        capabilities = capabilities,
      })

      vim.lsp.enable("lua_ls")
      vim.lsp.enable("vimls")
      vim.lsp.enable("pyright")
      vim.lsp.enable("qmlls")

      -- Disable semantic tokens for qmlls
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client and client.name == "qmlls" then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gD", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
