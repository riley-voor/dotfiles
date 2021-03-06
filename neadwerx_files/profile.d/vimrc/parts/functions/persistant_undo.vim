" Persistant undo
if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory(expand('~/.vim/undo/')) == 0
    exec 'silent !mkdir -p ~/.vim/undo/ > /dev/null 2>&1'
  endif
  set undodir=~/.vim/undo/
  set undofile
endif
