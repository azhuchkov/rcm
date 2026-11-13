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

Leading ./ components preserve top-level dotting in plain, tagged, and host paths

  $ mkdir -p .dotfiles/plain-bin .dotfiles/tag-work/tag-bin .dotfiles/host-$(hostname)/host-bin
  $ touch .dotfiles/plain-bin/tool .dotfiles/tag-work/tag-bin/tool .dotfiles/host-$(hostname)/host-bin/tool
  $ for name in plain-bin tag-bin host-bin; do
  >   rcup -t work -U "$name" "././$name"
  >   assert_linked "$HOME/$name/tool" "$(lsrc -t work -U "$name" "$name" | sed 's/^[^:]*://')"
  >   refute 'should not install outside HOME' -e "$HOME/../$name/tool"
  > done
  $ lsrc -U plain-bin -u plain-bin ./plain-bin/tool
  /*/.plain-bin/tool:/*/.dotfiles/plain-bin/tool (glob)
