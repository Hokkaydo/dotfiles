return {
    "lervag/vimtex",
    lazy=false,
    init = function ()
        vim.g.vimtex_view_method = 'zathura'
        vim.g.vimtex_compiler_latexmk_engines = {
            pdflatex = "-synctex=1 -shell-escape"
        }
        vim.g.vimtex_compiler_latexmk = {
            out_dir = "./build",
            options = {
                '-verbose',
                '-file-line-error',
                '-synctex=1',
                '-interaction=nonstopmode',
                '-shell-escape',
            }
        }

        -- Allow to ignore missing entries in BibTeX files
        vim.g.vimtex_quickfix_ignore_filters = {
            'Missing'
        }
    end
}
