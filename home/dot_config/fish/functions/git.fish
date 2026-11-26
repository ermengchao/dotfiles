function git
    if _is_dark_mode
        command git -c delta.features=catppuccin-mocha $argv
    else
        command git -c delta.features=catppuccin-latte $argv
    end
end
