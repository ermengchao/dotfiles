function codesnap
    if test $IS_DARK_MODE = true
        command codesnap --config $XDG_CONFIG_HOME/codesnap/catppuccin-mocha.json $argv
    else
        command codesnap --config $XDG_CONFIG_HOME/codesnap/catppuccin-latte.json $argv
    end
end
