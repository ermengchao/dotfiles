if status is-interactive
    and test -t 0
    and test -t 1
    and type -q tmux
    and not set -q TMUX
    and begin
        test "$TERM_PROGRAM" = ghostty
        or set -q SSH_CONNECTION
    end
    if set -q SSH_CONNECTION; and set -q IS_DARK_MODE
        set -Ux IS_DARK_MODE $IS_DARK_MODE
    end

    exec tmux new-session -A -s main
end
