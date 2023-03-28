fu! grepmenu#GrepChoseMode() abort
  echo 'mode 0: This File'
  echo 'mode 1: FULL AUTO [current ext, current word, current git root(no git -> current directory)]'
  echo 'mode 2: MANUAL EXT [Manual ext, current word, current git root(no git -> current directory)]'
  echo 'mode 3: ALL MANUAL [Manual ext, Manual word, Manual directory]'
  let mode = inputdialog("Enter [mode]>>")
  if mode == ''
    retu
  endif
  echo '<<'
  cal GrepExtFrom(mode)
endf

fu! GrepExtFrom(mode) abort
  if a:mode == 0 " this file
    echo 'grep from this file.'
    let word = inputdialog("Enter [word]>>")
    echo '<<'
    echo 'grep [' . word . '] processing in [' . expand('%') . '] ...'
    cal execute('vimgrep /' . word . '/gj %') | cw
    echo 'grep end'
    retu
  elseif a:mode == 1 " current ext, current word, current git root(no git -> current directory)
    let ext = expand('%:e')
    let word = expand('<cword>')
    let target = CurrentGitRoot()
  elseif a:mode == 2 " manual ext, current word, current git root(no git -> current directory)
    echo 'grep ['.expand('<cword>').'] from repo/*. choose [ext]'
    let ext = inputdialog("Enter [ext]>>")
    let word = expand('<cword>')
    let target = CurrentGitRoot()
  elseif a:mode == 3 " manual ext, manual word, manual directory
    echo 'grep. choose [ext] [word] [target]'
    let pwd = system('pwd')
    let ext = inputdialog("Enter [ext]>>")
    echo '<<'
    let word = inputdialog("Enter [word]>>")
    echo '<<'
    let target = inputdialog("Enter [target (like ./*) pwd:".pwd."]>>")
    let target = target == '' ? './*' : target
    echo '<<'
  endif
  echo 'grep [' . word . '] processing in [' . target . '] [' . ext . '] ...'
  cgetexpr system('grep -n -r --include="*.' . ext . '" "' . word . '" ' . target) | cw
  echo 'grep end'
endf

fu! CurrentGitRoot() " current git root(no git -> current directory)
  let pwd = system('pwd')
  exe 'lcd %:h'
  let gitroot = system('git rev-parse --show-superproject-working-tree --show-toplevel')
  exe 'lcd ' . pwd
  retu !v:shell_error ? gitroot[0:strlen(gitroot)-2] . '/*' : './*'
endf
