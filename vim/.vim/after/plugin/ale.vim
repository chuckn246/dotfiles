if has_key(g:plugs, "ale")
  " Fix on save
  let g:ale_fix_on_save = 0

  " Fixers to use when calling ALEFix
  let g:ale_fixers = {
  \   '*': ['remove_trailing_lines', 'trim_whitespace'],
  \   'json': ['jq'],
  \   'markdown': [],
  \   'python': ['isort', 'remove_trailing_lines', 'ruff', 'trim_whitespace'],
  \   'sh': ['shfmt', 'remove_trailing_lines', 'trim_whitespace'],
  \   'yaml': ['yamlfix', 'remove_trailing_lines', 'trim_whitespace'],
  \}

  " Fixers to ignore with fix on save
  let g:ale_fix_on_save_ignore = {
  \   'markdown': ['remove_trailing_lines', 'trim_whitespace'],
  \   'python': ['ruff'],
  \   'sh': ['shfmt'],
  \   'yaml': ['yamlfix']
  \}

  " Linters to enable
  let g:ale_linters = {
  \   'ansible': ['ansible_lint'],
  \   'cloudformation': ['cloudformation'],
  \   'dockerfile': ['hadolint'],
  \   'jinja': ['j2lint'],
  \   'json': ['jq'],
  \   'python': ['ruff', 'ty'],
  \   'sh': ['shellcheck'],
  \   'terraform': ['tflint'],
  \   'typescript': [],
  \   'yaml': ['yamllint', 'yq']
  \}

  " Configure shfmt
  let g:ale_sh_shfmt_options = '--case-indent --indent 2 --space-redirects'

  " Python uv and virtual envs
  let g:ale_python_auto_uv = 1
  let g:ale_python_pylint_auto_uv = 1
  let g:ale_python_ruff_auto_uv = 1
  let g:ale_python_auto_virtualenv = 1

  let g:ale_python_ty_auto_uv = 1
  let g:ale_python_ty_use_global = 1

  let g:ale_jinja_j2lint_auto_uv = 1
  let g:ale_jinja_j2lint_options ='--ignore jinja-statements-indentation single-statement-per-line --'

endif

" vim: ft=vim ts=2 sts=2 sw=2 nosr et
