if test (uname -s) = Darwin
    find $HOME/Dotfiles -name ".DS_Store" -type f -delete
    find $HOME/.config -name ".DS_Store" -type f -delete
    rm -f $HOME/.zshrc
    rm -f $HOME/.zprofile
    rm -f $HOME/.zshenv
    stow -R zsh
    stow -R zsh@x86

    rm -rf $HOME/.config/codesnap
    stow -R codesnap

    rm -rf $HOME/.config/git
    stow -R git
end

if test (uname -s) = Linux
    rm -rf $HOME/.config/mihomo
    mkdir -p $HOME/.config/mihomo
    stow -R mihomo

    rm -rf $HOME/.config/git
    stow -R git@Linux

    sudo rm -rf /etc/nginx
    sudo /home/linuxbrew/.linuxbrew/bin/stow -R nginx -t /

    sudo rm -rf /etc/samba
    sudo /home/linuxbrew/.linuxbrew/bin/stow -R samba -t /

    sudo /home/linuxbrew/.linuxbrew/bin/stow -R quadlet@system -t /
    stow -R quadlet@user
    sudo /home/linuxbrew/.linuxbrew/bin/stow -R systemd@system -t /
    stow -R systemd@user
end

rm -rf $HOME/.config/bat
stow -R bat

rm -rf $HOME/.config/bottom
stow -R bottom

rm -rf $HOME/.config/brew
stow -R homebrew

rm -rf $HOME/.config/bun
rm -rf $XDG_DATA_HOME/bun
mkdir -p $HOME/.local/share/bun
stow -R bun

rm -rf $HOME/.config/fish
mkdir $HOME/.config/fish
mkdir $HOME/.config/fish/completions
mkdir $HOME/.config/fish/conf.d
mkdir $HOME/.config/fish/functions
mkdir $HOME/.config/fish/themes
stow -R fish

rm -rf $HOME/.config/ghostty
stow -R ghostty

rm -rf $HOME/.config/nvim
stow -R nvim

rm -rf $HOME/.config/posting
stow -R posting

rm -rf $HOME/.ssh
mkdir $HOME/.ssh
touch $HOME/.ssh/authorized_keys
touch $HOME/.ssh/known_hosts
stow -R ssh

rm -rf $HOME/.config/tailscale
stow -R tailscale

rm -rf $HOME/.config/zellij
stow -R zellij
