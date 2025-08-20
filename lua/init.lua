local get_location = require'get_location'

vim.keymap.del('n', 'gx')

local lc_pword
local doc_hl = function(ev)
  local lc_cword = vim.fn.expand("<cword>")
  if (lc_pword == lc_cword) then
    return
  end
  vim.lsp.buf.clear_references()
  vim.lsp.buf.document_highlight()
  lc_pword = lc_cword
end

local ccls_root_dir
local lspconfig = require('lspconfig')
lspconfig.ccls.setup {
  init_options = {
    index = {
      threads = 16;
    },
    highlight = {
      rainbow = 10;
    }
  },
  root_dir = function(fname)
    -- force assign root_dir for headers out of project root (e.g., /usr/include)
    if not ccls_root_dir then
      ccls_root_dir = lspconfig.util.root_pattern('compile_commands.json', '.ccls')(fname) or
          vim.fs.dirname(vim.fs.find('.git', {path=fname, upward=true})[1])
    end
    return ccls_root_dir
  end,
  on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    local lopts = { loclist = true }
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition(lopts) end, opts)
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gr', function() vim.lsp.buf.references(nil, lopts) end, opts)
    vim.keymap.set('n', 'gs', function() vim.lsp.buf.document_symbol(lopts) end, opts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gxe', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', 'gxb', function() get_location('$ccls/inheritance', {}, lopts) end, opts)
    vim.keymap.set('n', 'gxB', function() get_location('$ccls/inheritance', {levels=3}, lopts) end, opts)
    vim.keymap.set('n', 'gxd', function() get_location('$ccls/inheritance', {derived=true}, lopts) end, opts)
    vim.keymap.set('n', 'gxD', function() get_location('$ccls/inheritance', {derived=true, levels=3}, lopts) end, opts)
    vim.keymap.set('n', 'gxc', function() get_location('$ccls/call', {}, lopts) end, opts)
    vim.keymap.set('n', 'gxC', function() get_location('$ccls/call', {callee=true}, lopts) end, opts)
    vim.keymap.set('n', 'gxs', function() get_location('$ccls/member', {kind=2}, lopts) end, opts)
    vim.keymap.set('n', 'gxf', function() get_location('$ccls/member', {kind=3}, lopts) end, opts)
    vim.keymap.set('n', 'gxm', function() get_location('$ccls/member', {}, lopts) end, opts)
    vim.keymap.set('n', '<C-j>', function() get_location('$ccls/navigate', {direction='D'}, lopts) end, opts)
    vim.keymap.set('n', '<C-k>', function() get_location('$ccls/navigate', {direction='U'}, lopts) end, opts)
    vim.keymap.set('n', '<C-h>', function() get_location('$ccls/navigate', {direction='L'}, lopts) end, opts)
    vim.keymap.set('n', '<C-l>', function() get_location('$ccls/navigate', {direction='R'}, lopts) end, opts)
    vim.api.nvim_create_autocmd('CursorMoved', {callback = doc_hl})
    vim.api.nvim_set_hl(0, '@lsp.type.field', {link = 'Member'})
    vim.api.nvim_set_hl(0, '@lsp.type.typeAlias', {link = 'Type'})
    vim.api.nvim_set_hl(0, '@lsp.type.constructor', {link = 'Identifier'})
    -- vim.lsp.completion.enable(true, client.id, bufnr, {
    --   autotrigger = true,
  	-- })
  end,
  -- required by nvim-cmp
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

local cmp = require'cmp'
cmp.setup({
  window = {
    completion = {
      winhighlight = "Normal:Pmenu"
    },
    documentation = {
      winhighlight = "Normal:Pmenu"
    },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-c>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
)
equire("cmp_git").setup() ]]-- 

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  },
  {
    { name = 'cmdline' }
  }
  ),
  matching = { disallow_symbol_nonprefix_matching = false }
})
