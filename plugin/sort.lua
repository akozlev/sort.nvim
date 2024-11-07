vim.cmd(
  [[ command! -nargs=* -bang -range Sort :lua require('sort').command("<bang>", <q-args>) ]]
)
