if status is-interactive
    and type -q tmux
    and not set -q TMUX
    and begin
        test "$TERM_PROGRAM" = ghostty
        or set -q SSH_CONNECTION
    end
    exec tmux new-session -A -s main
end
