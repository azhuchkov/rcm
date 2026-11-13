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

Explicit -U resolves relative filenames from a subdirectory

  $ echo undotted > scripts/subfolder/relative
  $ (cd scripts/subfolder && mkrc -U relative)
  $ assert_linked "$HOME/scripts/subfolder/relative" "$HOME/.dotfiles/scripts/subfolder/relative"
  $ cat scripts/subfolder/relative
  undotted
  $ refute 'should not create .scripts' -e "$HOME/.scripts"

Explicit -u overrides UNDOTTED for relative filenames from a subdirectory

  $ echo 'UNDOTTED="folder"' > .rcrc
  $ echo dotted > .folder/subfolder/relative
  $ (cd .folder/subfolder && mkrc -u relative)
  $ assert_linked "$HOME/.folder/subfolder/relative" "$HOME/.dotfiles/folder/subfolder/relative"
  $ cat .folder/subfolder/relative
  dotted
  $ refute 'should not create an undotted link' -e "$HOME/folder/subfolder/relative"

Dotting overrides preserve spaces in parent directories and multiple operands

  $ mkdir -p 'my scripts' '.my scripts'
  $ touch 'my scripts/tool' 'my scripts/other' '.my scripts/dotted'
  $ (cd 'my scripts' && mkrc -U tool other)
  $ assert_linked "$HOME/my scripts/tool" "$HOME/.dotfiles/my scripts/tool"
  $ assert_linked "$HOME/my scripts/other" "$HOME/.dotfiles/my scripts/other"
  $ echo 'UNDOTTED="*"' > .rcrc
  $ (cd '.my scripts' && mkrc -u dotted)
  $ assert_linked "$HOME/.my scripts/dotted" "$HOME/.dotfiles/my scripts/dotted"
