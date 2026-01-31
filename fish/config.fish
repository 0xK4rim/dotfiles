function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

# Fast CP
function CP
  set -l CP_ROOT ~/K/Study/CP/
  nvim "$CP_ROOT/$argv[1]"
end

# LaTeX Template
function templatex
  set -l DIR ~/.config/LaTeX-Template
  cp "$DIR/letterfonts.tex" "$DIR/macros.tex" "$DIR/preamble.tex" "$DIR/template.tex" ./
end

if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

    # Use starship
    starship init fish | source
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases
    alias pamcan pacman
    alias ls 'eza --icons'
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias q 'qs -c ii'
    alias EditNvimCheatsheet "nvim ~/.config/quickshell/ii/modules/ii/cheatsheet/NeovimKeybinds.qml"
end

