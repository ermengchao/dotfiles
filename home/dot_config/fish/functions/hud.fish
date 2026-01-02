function hud
    if test (count $argv) -eq 0
        /bin/launchctl getenv MTL_HUD_ENABLED
        return
    end

    switch $argv[1]
        case on
            /bin/launchctl setenv MTL_HUD_ENABLED 1
            echo "HUD enabled."
        case off
            /bin/launchctl setenv MTL_HUD_ENABLED 0
            echo "HUD disabled."
        case '*'
            echo "Usage: hud [on|off]"
    end
end
