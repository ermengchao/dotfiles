if test (uname -s) = Darwin
    # Homebrew
    /opt/homebrew/bin/brew shellenv | source
    # /opt/homebrew/bin/whalebrew completion fish | source

    # Orbstack
    source ~/.orbstack/shell/init2.fish 2>/dev/null || :

    # SSH-Agent
    abbr keychain-add "/usr/bin/ssh-add --apple-use-keychain"

    # Abbreviation
    alias cat "bat --theme auto:system --theme-dark default --theme-light GitHub --style='numbers,changes,header'"
    abbr x86 "arch -arm64 env ZDOTDIR='$HOME/.zsh@x86' zsh"
    abbr xcode "open -a Xcode"

    # Functions
    # Adapt Dynamic Terminal Theme
    # if test "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = Dark
    #     osascript -e 'tell application "Terminal"
    #         set current settings of tabs of windows to settings set "Transparent Dark" -- Theme name
    #     end tell'
    # else
    #     osascript -e 'tell application "Terminal"
    #         set current settings of tabs of windows to settings set "Transparent Light" -- Theme name
    #     end tell'
    # end
end

if test (uname -s) = Linux
    # Homebrew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv fish | source
    # /home/linuxbrew/.linuxbrew/bin/whalebrew completion fish | source

    # SSH-Agent
    eval "$(ssh-agent -c 2>/dev/null)" >/dev/null

    # Abbreviation
    abbr psg /usr/lib/systemd/system-generators/podman-system-generator
    abbr sc systemctl
    abbr scu "systemctl --user"
    alias tailscale "tailscale --socket $XDG_RUNTIME_DIR/tailscale/tailscaled.sock"

    # Functions
    function sys_color_scheme_is_dark
        set -l condition (gsettings get org.gnome.desktop.interface color-scheme \
          | string trim \
          | string trim -c "'")

        if test "$condition" = prefer-dark
            return 0
        else
            return 1
        end
    end

    function bat_alias_wrapper
        if sys_color_scheme_is_dark
            bat --theme=default $argv
        else
            bat --theme=GitHub $argv
        end
    end

    alias cat="bat_alias_wrapper --style='numbers,changes,header'"
end

if status is-interactive
    # eval (zellij setup --generate-auto-start fish | string collect)
    # function fish_greeting
    #     echo "Welcome to $(uname -s)!"
    # end
end

fzf --fish | source
zoxide init --cmd cd fish | source

# Key Binding
bind \t complete
bind \ce $EXPLORER

# Abbreviation
# bat
abbr -a --position anywhere -- --help '--help | bat -plhelp'
abbr -a --position anywhere -- -h '-h | bat -plhelp'

abbr apy "source ./.venv/bin/activate.fish"
abbr activate "source .venv/bin/activate.fish"
abbr dpy deactivate
abbr f fastfetch
abbr fzfp "fzf --style full --preview 'fzf-preview.sh {}'"
abbr ipy "uv init --no-readme"
abbr jnote "jupyter notebook"
abbr jlab "jupyter lab"
abbr n nvim
abbr s source
abbr td "tailscale down"
abbr tp "tailscale ping"
abbr ts "tailscale status"
abbr tu "tailscale up"

# Functions
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function clisnap --description 'Snapshot CLI output to clipboard via CodeSnap'
    set tmp (mktemp -t "clisnap.XXXXXX")
    cat >$tmp
    if test -s $tmp
        codesnap --from-file $tmp --output clipboard --silent
        set -l exit_code $status
        rm -f $tmp

        if test $exit_code -eq 0
            echo "CliSnap saved to clipboard successfully."
        else
            echo "CliSnap failed with exit code $exit_code" >&2
        end
    else
        rm -f -- "$tmp"
        echo "No input received, nothing to snapshot." >&2
    end
end
