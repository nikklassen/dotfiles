local lsp_status = require('lsp-status')
return {
    configure = function ()
        lsp_status.config {
            current_function = false,
            show_filename = false,
            indicator_errors = 'E',
            indicator_warnings = 'W',
            indicator_info = 'i',
            indicator_hint = '?',
            indicator_ok = 'Ok',
            status_symbol = '',
        }
        lsp_status.register_progress()
    end,
}
