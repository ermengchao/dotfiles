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

    According to [chezmoi's design principle](<https://www.chezmoi.io/user-guide/frequently-asked-questions/design/#can-i-use-chezmoi-to-manage-files-outside-my-home-directory>), 'chezmoi' is designed as a user scope dotfiles' manager. The best practise to organize files outside, I think, is to manage file in the repository but deploy them manually. It can be a script, or a symlink just like [GNU Stow](<https://www.gnu.org/software/stow/>)
3. How to manage the encrypted files?

    At beginning, I encrypted every files which contain sensitive data, like API keys, password, etc.

    But soon I've realized: there's a lot of files which need shared sensitive configurations, like `GITHUB_PAT` is needed by both `fish/conf.d/env.fish` and `.codex/config.toml`. So why not just using `chezmoi/config.toml` to manage all of my secrets, and call them in a template file? The another benefit is: we are not required to decrypt the file before we edit it. Cool! :sunglasses:
