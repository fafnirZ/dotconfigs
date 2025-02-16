-- python
-- https://github.com/astral-sh/ruff-lsp/issues/23#issuecomment-2571330722

--pyright and ruff
require('lspconfig').ruff.setup {
  trace = 'messages',
  init_options = {
    settings = {
      logLevel = 'debug',
    }
  }
}

require('lspconfig').pyright.setup{
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "off",
                autoImportCompletions = false,
            },
            linting = {
                enabled = false,
            }
        }
    },
    -- Disable all diagnostics from Pyright
    handlers = {
        ["textDocument/publishDiagnostics"] = function() end,
    }
}

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set('n', '<C-o>', '<C-o>', { noremap = true, silent = true })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })

vim.api.nvim_create_augroup("AutoFormat", {})
vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.py",
        group = "AutoFormat",
        callback = function()
            vim.cmd("silent !ruff format %")            
            vim.cmd("edit")
        end,
    }
)

