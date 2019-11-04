for DOTFILE in ./src/**/.*
do
  [ -f "$DOTFILE" ] && source "$DOTFILE"
done
