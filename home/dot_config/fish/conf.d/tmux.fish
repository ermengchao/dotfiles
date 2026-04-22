if status is-interactive
    and type -q tmux
    and not set -q TMUX
    and test "$TERM_PROGRAM" = ghostty
    exec tmux new-session -A -s main
end
