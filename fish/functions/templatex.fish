function templatex
  set -l arg $argv[1]
  if test (count $argv) -eq 0
    echo "Choose which template"
    return 1
  end
  switch $arg
    case handout
      cp ~/.config/LaTeX-Templates/Mine/example.tex ./
      nvim example.tex
    case CMT
      set -l DIR ~/.config/LaTeX-Templates/CMT/
      cp "$DIR/letterfonts.tex" "$DIR/macros.tex" "$DIR/preamble.tex" "$DIR/template.tex" ./
      return 0
  end
end
