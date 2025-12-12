if test (uname -s) = Darwin:
    if test -x /usr/libexec/path_helper
        eval (/usr/libexec/path_helper -s)
    end

    fish_add_path /opt/homebrew/opt/coreutils/libexec/gnubin
    fish_add_path /opt/homebrew/opt/git/bin
    fish_add_path /opt/homebrew/opt/openjdk/bin
    fish_add_path "/Applications/Surge.app/Contents/Applications"
    fish_add_path "/Applications/Tailscale.app/Contents/MacOS"
end

fish_add_path "$HOME/.local/bin"
