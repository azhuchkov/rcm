  $ . "$TESTDIR/helper.sh"
  > touch random-dotfile

Passing -U should make a file be undotted

  $ mkrc -U random-dotfile  >/dev/null

  $ assert_linked "$HOME/random-dotfile" "$HOME/.dotfiles/random-dotfile"

Configured UNDOTTED applies to a top-level directory when adding a nested file

  $ echo 'UNDOTTED="bin folder*"' > .rcrc
  $ mkdir -p bin folder/subfolder
  $ echo script > bin/foo.sh
  $ mkrc "$HOME/bin/foo.sh"
  $ assert_linked "$HOME/bin/foo.sh" "$HOME/.dotfiles/bin/foo.sh"
  $ cat bin/foo.sh
  script
  $ refute 'should not create .bin' -e "$HOME/.bin"

Wildcard patterns also apply to nested files in tagged and host-specific paths

  $ touch folder/subfolder/plain folder/subfolder/tagged folder/subfolder/host
  $ mkrc folder/subfolder/plain
  $ mkrc -t work folder/subfolder/tagged
  $ mkrc -o folder/subfolder/host
  $ assert_linked "$HOME/folder/subfolder/plain" "$HOME/.dotfiles/folder/subfolder/plain"
  $ assert_linked "$HOME/folder/subfolder/tagged" "$HOME/.dotfiles/tag-work/folder/subfolder/tagged"
  $ assert_linked "$HOME/folder/subfolder/host" "$HOME/.dotfiles/host-$(hostname)/folder/subfolder/host"
  $ refute 'should not create .folder' -e "$HOME/.folder"

Explicit -u overrides UNDOTTED for a nested file

  $ mkdir -p .folder/subfolder
  $ touch .folder/subfolder/dotted
  $ mkrc -u .folder/subfolder/dotted
  $ assert_linked "$HOME/.folder/subfolder/dotted" "$HOME/.dotfiles/folder/subfolder/dotted"

Explicit -U applies to a nested file without configuration

  $ rm .rcrc
  $ mkdir -p scripts/subfolder
  $ touch scripts/subfolder/file
  $ mkrc -U scripts/subfolder/file
  $ assert_linked "$HOME/scripts/subfolder/file" "$HOME/.dotfiles/scripts/subfolder/file"
