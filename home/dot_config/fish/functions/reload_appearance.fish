function reload_appearance
    if set -q TMUX
        tmux source-file $XDG_CONFIG_HOME/tmux/tmux.conf; or true
    end

    __apply_appearance
    tide reload
    commandline -f repaint
    return 0
end
