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
    automatic_enable = lsps,
})

-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local default_lsp_capabilities = {
      autostart = true,
      capabilities = {
        general = {
          positionEncodings = { "utf-8", "utf-16", "utf-32" }
        },
        textDocument = {
          callHierarchy = {
            dynamicRegistration = false
          },
          codeAction = {
            codeActionLiteralSupport = {
              codeActionKind = {
                valueSet = { "", "quickfix", "refactor", "refactor.extract", "refactor.inline", "refactor.rewrite", "source", "source.organizeImports" }
              }
            },
            dataSupport = true,
            dynamicRegistration = true,
            isPreferredSupport = true,
            resolveSupport = {
              properties = { "edit", "command" }
            }
          },
          codeLens = {
            dynamicRegistration = false,
            resolveSupport = {
              properties = { "command" }
            }
          },
          completion = {
            completionItem = {
              commitCharactersSupport = false,
              deprecatedSupport = true,
              documentationFormat = { "markdown", "plaintext" },
              preselectSupport = false,
              resolveSupport = {
                properties = { "additionalTextEdits", "command" }
              },
              snippetSupport = true,
              tagSupport = {
                valueSet = { 1 }
              }
            },
            completionItemKind = {
              valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 }
            },
            completionList = {
              itemDefaults = { "editRange", "insertTextFormat", "insertTextMode", "data" }
            },
            contextSupport = true,
            dynamicRegistration = false
          },
          declaration = {
            linkSupport = true
          },
          definition = {
            dynamicRegistration = true,
            linkSupport = true
          },
          diagnostic = {
            dynamicRegistration = false,
            tagSupport = {
              valueSet = { 1, 2 }
            }
          },
          documentHighlight = {
            dynamicRegistration = false
          },
          documentSymbol = {
            dynamicRegistration = false,
            hierarchicalDocumentSymbolSupport = true,
            symbolKind = {
              valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 }
            }
          },
          foldingRange = {
            dynamicRegistration = false,
            foldingRange = {
              collapsedText = true
            },
            foldingRangeKind = {
              valueSet = { "comment", "imports", "region" }
            },
            lineFoldingOnly = true
          },
          formatting = {
            dynamicRegistration = true
          },
          hover = {
            contentFormat = { "markdown", "plaintext" },
            dynamicRegistration = true
          },
          implementation = {
            linkSupport = true
          },
          inlayHint = {
            dynamicRegistration = true,
            resolveSupport = {
              properties = { "textEdits", "tooltip", "location", "command" }
            }
          },
          publishDiagnostics = {
            dataSupport = true,
            relatedInformation = true,
            tagSupport = {
              valueSet = { 1, 2 }
            }
          },
          rangeFormatting = {
            dynamicRegistration = true,
            rangesSupport = true
          },
          references = {
            dynamicRegistration = false
          },
          rename = {
            dynamicRegistration = true,
            prepareSupport = true
          },
          semanticTokens = {
            augmentsSyntaxTokens = true,
            dynamicRegistration = false,
            formats = { "relative" },
            multilineTokenSupport = false,
            overlappingTokenSupport = true,
            requests = {
              full = {
                delta = true
              },
              range = false
            },
            serverCancelSupport = false,
            tokenModifiers = { "declaration", "definition", "readonly", "static", "deprecated", "abstract", "async", "modification", "documentation", "defaultLibrary" },
            tokenTypes = { "namespace", "type", "class", "enum", "interface", "struct", "typeParameter", "parameter", "variable", "property", "enumMember", "event", "function", "method", "macro", "keyword", "modifier", "comment", "string", "number", "regexp", "operator", "decorator" }
          },
          signatureHelp = {
            dynamicRegistration = false,
            signatureInformation = {
              activeParameterSupport = true,
              documentationFormat = { "markdown", "plaintext" },
              parameterInformation = {
                labelOffsetSupport = true
              }
            }
          },
          synchronization = {
            didSave = true,
            dynamicRegistration = false,
            willSave = true,
            willSaveWaitUntil = true
          },
          typeDefinition = {
            linkSupport = true
          }
        },
        window = {
          showDocument = {
            support = true
          },
          showMessage = {
            messageActionItem = {
              additionalPropertiesSupport = true
            }
          },
          workDoneProgress = true
        },
        workspace = {
          applyEdit = true,
          configuration = true,
          didChangeConfiguration = {
            dynamicRegistration = false
          },
          didChangeWatchedFiles = {
            dynamicRegistration = false,
            relativePatternSupport = true
          },
          inlayHint = {
            refreshSupport = true
          },
          semanticTokens = {
            refreshSupport = true
          },
          symbol = {
            dynamicRegistration = false,
            symbolKind = {
              valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 }
            }
          },
          workspaceEdit = {
            resourceOperations = { "rename", "create", "delete" }
          },
          workspaceFolders = true
        }
      },
    }

vim.lsp.config('*', {
    capabilities = cmp_capabilities
})

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
        vim.keymap.set('n', '<leader>lc', '<cmd>lua vim.lsp.buf.incoming_calls()<cr>',opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set({ 'n', 'v'}, '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set('n', '<F5>', function ()
            vim.lsp.codelens.refresh({bufnr=bufnr})
            vim.lsp.codelens.display(bufnr, client_id)
        end, opts)
    end,
})

-- You'll find a list of language servers here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- These are example language servers.

vim.lsp.enable('kotlin_language_server')
vim.lsp.enable('gleam')
vim.lsp.enable('ocamllsp')
if os ~= "Windows" then
    vim.lsp.config('gdscript', {
        name="godot",
        cmd= vim.lsp.rpc.connect("127.0.0.1", 6005)
    })
    vim.lsp.enable('qmlls')
else
    vim.lsp.config('gdscript', {
        name="godot",
        cmd= vim.lsp.rpc.connect("127.0.0.1","6008"),
    })
end
vim.lsp.enable('gdscript')
vim.lsp.enable('ts_ls')
vim.lsp.enable('helm_ls')

-- begin Terraform config
vim.lsp.enable('terraformls')
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})
-- end Terraform config


local cmp = require('cmp')

cmp.setup({
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'buffer-lines' },
        { name = 'path' },
    }),
    snippet = {
        expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' },
        { name = 'buffer-lines' },
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
