-- NOTE: to make any of this work you need a language server.
-- If you don't know what that is, watch this 5 min video:
-- https://www.youtube.com/watch?v=LaS32vctfOY

require("mason").setup({})

local lsps = { "lua_ls", "terraformls", "kotlin_language_server" }
local os = jit.os
-- Add lsps that aren't haven't been configured in Windows yet
if os ~= "Windows" then
    table.insert(lsps,"jsonls")
    table.insert(lsps,"ts_ls")
    table.insert(lsps,"helm_ls")
    table.insert(lsps,"bashls")
    -- table.insert(lsps,"yamlls")
end

require("mason-lspconfig").setup({
    ensure_installed = lsps,
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
    }

})

-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    cmp_capabilities
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        local bufnr = event.buf
        local client_id = event.data.client_id

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', '<leader>gc', '<cmd>lua vim.lsp.buf.incoming_calls()<cr>',opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set('v', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set('n', '<F5>', function ()
            vim.lsp.codelens.refresh({bufnr=bufnr})
            vim.lsp.codelens.display(bufnr, client_id)
        end, opts)
    end,
})

-- You'll find a list of language servers here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- These are example language servers.

local lspconfig = require('lspconfig')
lspconfig.kotlin_language_server.setup({})
lspconfig.gleam.setup({})
lspconfig.ocamllsp.setup({})
if os ~= "Windows" then
    lspconfig.gdscript.setup({
        name="godot",
        cmd= { "godot-wsl-lsp", "--useMirroredNetworking" },
    })
else
    lspconfig.gdscript.setup({
        name="godot",
        cmd= vim.lsp.rpc.connect("127.0.0.1","6008"),
    })
end
lspconfig.lua_ls.setup({})
lspconfig.ts_ls.setup({})
lspconfig.helm_ls.setup({})

local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' },
    },
    snippet = {
        expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.scroll_docs(-4),
        ['<C-p>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})
cmp.setup.cmdline(':', {

    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

vim.keymap.set({ 'i', 's' }, '<Tab>', function()
   if vim.snippet.active({ direction = 1 }) then
     return '<cmd>lua vim.snippet.jump(1)<cr>'
   else
     return '<Tab>'
   end
 end, { expr = true })
