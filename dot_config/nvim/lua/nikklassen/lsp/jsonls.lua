vim.lsp.config('jsonls', {
  settings = {
    json = {
      schemas = {
        {
          fileMatch = { '*.fhir.json' },
          url = 'https://hl7.org/fhir/r4/fhir.schema.json',
        },
      },
      validate = {
        enable = true,
      },
    },
  },
})
vim.lsp.enable('jsonls')
