  $ . "$TESTDIR/helper.sh"

Keeps globs as globs

  $ mkdir vimulator
  > lsrc -vvv -x '*vim*' 2>&1 | grep exclude_file_globs
  exclude_file_globs: *vim*

Match patterns without reinterpreting metacharacters in matching filenames

  $ mkdir -p '.dotfiles/folder[1]/subfolder'
  $ touch '.dotfiles/folder[1]/subfolder/file'
  $ lsrc -U 'unused folder*' 'folder[1]/subfolder/file' | sed "s|$HOME|HOME|g"
  HOME/folder[1]/subfolder/file:HOME/.dotfiles/folder[1]/subfolder/file

Dotting exceptions also retain their patterns

  $ lsrc -U '*' -u 'unused folder*' 'folder[1]/subfolder/file' | sed "s|$HOME|HOME|g"
  HOME/.folder[1]/subfolder/file:HOME/.dotfiles/folder[1]/subfolder/file

Pattern matching leaves directory traversal globbing enabled

  $ lsrc -U 'folder*' | sed "s|$HOME|HOME|g"
  HOME/folder[1]/subfolder/file:HOME/.dotfiles/folder[1]/subfolder/file
