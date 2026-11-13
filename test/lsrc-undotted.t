  $ . "$TESTDIR/helper.sh"

Should undot files with -U

  $ touch .dotfiles/example
  > touch .dotfiles/undotted

  $ lsrc -U undotted
  /*/.example:/*/.dotfiles/example (glob)
  /*/undotted:/*/.dotfiles/undotted (glob)

Explicit nested paths use the same dotting rules as directory traversal

  $ mkdir -p .dotfiles/bin/subfolder
  $ touch .dotfiles/bin/subfolder/file
  $ lsrc -U bin bin/subfolder/file
  /*/bin/subfolder/file:/*/.dotfiles/bin/subfolder/file (glob)
  $ lsrc -U bin -u bin bin/subfolder/file
  /*/.bin/subfolder/file:/*/.dotfiles/bin/subfolder/file (glob)
  $ lsrc -U 'bin/*' bin/subfolder/file
  /*/.bin/subfolder/file:/*/.dotfiles/bin/subfolder/file (glob)

