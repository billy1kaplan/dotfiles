Dotfile configs

### Simple setup assuming that the dotfiles folder is placed under $HOME
```
for DOTFILE in ~/.dotfiles/src/**/.*
do
  [ -f "$DOTFILE" ] && source "$DOTFILE"
done
```
