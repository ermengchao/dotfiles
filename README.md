# dotfiles

> My personal dotfiles repository for macOS and Linux. It uses [chezmoi](<https://github.com/twpayne/chezmoi>) to manage and deploy configuration files in a clean and maintainable way.

## Principle

1. How to manage `text/template`?

    - `{{ }}`: respect all the whitespace
    - `{{- }}`: ignore left whitespace
    - `{{ -}}`: ignore right whitespace

    For example:

    ```go
    line1
    
    {{- }}
    line2
    {{- -}}
    line3
    {{ -}}

    line4
    ```

    will be rendered as this:

    ```text
    line1
    line2line3
    line4
    ```

    So, the best practise is:

    |`text/template`|domain|position|
    |:-:|:-:|:-:|
    |`{{- -}}`|file|top, bottom|
    |`{{ -}}`|block|top, middle|
    |`{{- }}`|block|end|
    |`{{ }}`|line|head, middle, end|

2. How to manage files outside the home directory, like `etc/caddy`, etc.?

    According to [chezmoi's design principles](<https://www.chezmoi.io/user-guide/frequently-asked-questions/design/#can-i-use-chezmoi-to-manage-files-outside-my-home-directory>), `chezmoi` is primarily a user-scoped dotfiles manager. Files outside the user's home directory are therefore kept in this repository under a separate `root` source tree and deployed explicitly.

    On Linux systems other than NixOS, the executable template `home/dot_local/bin/executable_chezmoi-apply-etc.tmpl` installs the external command `chezmoi-apply-etc`. Running `chezmoi apply-etc` starts a second Chezmoi process with `sudo`, uses `{{ .chezmoi.workingTree }}/root` as its source directory, and uses `/` as its destination. Consequently, paths are mapped directly to their system locations: `root/etc/...` becomes `/etc/...`, `root/root/...` becomes `/root/...`, and `root/usr/...` becomes `/usr/...`. These files are applied by Chezmoi; they are not deployed as symlinks.

    The root source tree is not applied by the regular `chezmoi apply` command. Its pending changes can be inspected with `chezmoi apply-etc --dry-run --verbose` and applied explicitly with `chezmoi apply-etc`.

3. How to manage the encrypted files?

    At beginning, I encrypted every files which contain sensitive data, like API keys, password, etc.

    But soon I've realized: there's a lot of files which need shared sensitive configurations, like `GITHUB_PAT` is needed by both `fish/conf.d/env.fish` and `.codex/config.toml`. So why not just using `chezmoi/config.toml` to manage all of my secrets, and call them in a template file? The another benefit is: we are not required to decrypt the file before we edit it. Cool!

    But there's another uncool fact that I've realized later: once I modified or add/remove a secret, I had to reinitialize the `.chezmoi.toml.tmpl`, and it also may cause dotfiles out of sync. So, I turned to password manager eventually. I use Apple Password in my daily life, which is natively suppouted across apple device and support biometric unlock. The disadvantage is, it doesn't support command line interface yet and the community project, like [apw](<https://github.com/bendews/apw>), are no longer valid since macOS 26. So, I finally decided to manage my password in two manager, another one is `gopass`. I use Apple Password to mainly store password of websites, and `gopass` to mainly store API keys .etc which is more common in command line interface.

4. How to manage dotfiles on NixOS?

    NixOS is an unique linux distro. It supports using reproducible configuration to manage the system. As for dotfiles, there's a native nix module called `Home Manager`. But given to its following disadvantages, I decided to keep using chezmoi on NixOS:

    1. Not all packages have native nixos's modules. Try to manage them will cause a sense of disconnect.
    2. Using 'Home Manager' as my only package manager will cause inconvenience which means I have to install nix first on normal linux distro, such as arch and fedora. Using both manager is inconvenient too.

    So, I only use `Home Manager` to manage packages to be installed. Another key fact is, NixOS is declarative, so we should avoid using the `run_*` scripts on NixOS, but using `Home Manager` to manage.
