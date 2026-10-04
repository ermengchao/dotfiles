# dotfiles

English | [简体中文](README.zh-CN.md)

> My personal dotfiles repository for macOS and Linux. It uses [chezmoi](<https://github.com/twpayne/chezmoi>) to manage and deploy configuration files in a clean and maintainable way.

## Principle

1. How to manage files outside the home directory, like `etc/caddy`, etc.?

    According to [chezmoi's design principles](<https://www.chezmoi.io/user-guide/frequently-asked-questions/design/#can-i-use-chezmoi-to-manage-files-outside-my-home-directory>), `chezmoi` is primarily a user-scoped dotfiles manager. Files outside the user's home directory are therefore kept in this repository under a separate `root` source tree and deployed explicitly.

    On Linux systems other than NixOS, the executable template `home/dot_local/bin/executable_chezmoi-apply-root.tmpl` installs the external command `chezmoi-apply-root`. Running `chezmoi apply-root` starts a second Chezmoi process with `sudo`, uses `{{ .chezmoi.workingTree }}/root` as its source directory, and uses `/` as its destination. Consequently, paths are mapped directly to their system locations: `root/etc/...` becomes `/etc/...`, `root/root/...` becomes `/root/...`, and `root/usr/...` becomes `/usr/...`. These files are applied by Chezmoi; they are not deployed as symlinks.

    The root source tree is not applied by the regular `chezmoi apply` command. Its pending changes can be inspected with `chezmoi apply-root --dry-run --verbose` and applied explicitly with `chezmoi apply-root`.

2. How to manage secrets and encrypted files?

    I initially encrypted every file containing sensitive data, such as passwords and API keys. However, multiple files often need the same secret: for example, both `fish/conf.d/env.fish` and `.codex/config.toml` may need `GITHUB_PAT`. Keeping those secrets in `chezmoi/config.toml` and referencing them from templates reduced duplication and allowed me to edit templates without decrypting entire files first.

    This approach still required me to reinitialize `.chezmoi.toml.tmpl` whenever I added, changed, or removed a secret, which could leave configurations out of sync. I eventually moved secret management to dedicated password managers, with two separate stores based on how I use their contents.

    **Two kinds of secrets**

    - **Everyday credentials**, such as website logins:
        - Rarely used in the CLI.
        - Need to be available across multiple devices, including phones.
        - Need seamless integration when filling in or generating passwords.
    - **Development and infrastructure secrets**, such as API keys, access tokens, and SSH private keys:
        - Frequently used in the CLI, with convenient viewing, import, and export.
        - Only need to support my desktop and command-line workflow; mobile clients are unnecessary.

    1Password could potentially handle both categories, but its subscription cost and integration with Safari and iPhone do not meet my expectations for this workflow. In particular, I want a consistent experience when entering credentials in system interfaces such as Settings and the App Store. I therefore use two tools:

    - **Apple Passwords** for everyday credentials, with native integration across my Apple devices.
    - **gopass** for development and infrastructure secrets, where command-line access matters most.

    gopass also provides the encrypted secret store for my chezmoi-managed dotfiles. Templates retrieve shared secrets from gopass, keeping sensitive values encrypted in the store rather than duplicating them across source files.

    chezmoi uses age for encrypted files. This repository currently contains no chezmoi-encrypted files, so the `[age]` identity and recipients settings are commented out; the SSH key paths remain as examples for future use. These settings are independent of gopass: before the first apply on a root node, import an existing native age identity with `gopass age identities add`, or generate one with `gopass age identities keygen`. gopass keeps it in its encrypted keyring at `~/.config/gopass/age/identities`. A newly generated identity must also be added as a recipient and the existing secrets re-encrypted on a device that can already decrypt the store. Leaf nodes use `~/.ssh/id_ed25519` instead.

    **Root and leaf clients**

    My workflow also distinguishes between two roles in the SSH connection topology. Here, *root* describes a device's role in that topology, not the Unix `root` account.

    - **Root clients** are typically laptops:
        - Frequently initiate SSH connections to leaf clients and are rarely accessed as SSH servers.
        - Usually support biometric authentication, such as Touch ID.
    - **Leaf clients** are typically desktop computers, home servers, NAS devices, or cloud servers:
        - Frequently receive SSH connections, although they may also initiate them.
        - Have limited biometric authentication support, especially during remote access.

    ```mermaid
    flowchart TD
        A[MacBook]
        B[Linux Laptop]

        A --> C[Home Server]
        A --> D[NAS]
        A --> E[AWS EC2]

        B --> C
        B --> D
        B --> E
    ```

    These different roles call for different decryption and synchronization settings. The `meta.isRootNode` setting selects the role and its gopass configuration:

    - **Root clients** use dedicated age identities for decryption. A native age private key is the baseline; where supported, plugin-backed identities can integrate with biometric authentication or hardware tokens, such as [Apple's Secure Enclave](https://github.com/remko/age-plugin-se) or [YubiKey](https://github.com/str4d/age-plugin-yubikey). These capabilities require the corresponding plugins rather than a plain age private key alone.
      gopass enables `core.autopush` and `core.autosync` on these nodes, allowing bidirectional synchronization.
    - **Leaf clients** use their existing SSH private keys for decryption through [age's SSH key support](https://github.com/FiloSottile/age#ssh-keys), simplifying initial setup and reducing the number of keys I need to maintain.
      gopass disables both `core.autopush` and `core.autosync` on these nodes. The chezmoi pull script retrieves updates with `gopass --yes --nosync git -- pull --ff-only`, without pushing or creating merge commits. It fails if the local and remote histories have diverged.

    `gopass sync` performs a Git pull followed by a push; its pull does not explicitly use `--ff-only`. Disabling `core.autopush` stops automatic pushes after local changes, while disabling `core.autosync` stops automatic bidirectional sync. Neither setting prevents an explicit `gopass sync`, so leaf nodes use the pull command above for updates. The same chezmoi pull script also runs on root nodes.

    In my own setup, I never need to SSH into root nodes, and I do not configure SSH private keys on them either; I use only a native age identity for decryption. Each node therefore needs just one key for the secret store: an age key on root nodes, or an existing SSH key on leaf nodes. A neat, minimal setup.

3. How to manage dotfiles on NixOS?

    NixOS is an unique linux distro. It supports using reproducible configuration to manage the system. As for dotfiles, there's a native nix module called `Home Manager`. But given to its following disadvantages, I decided to keep using chezmoi on NixOS:

    1. Not all packages have native nixos's modules. Try to manage them will cause a sense of disconnect.
    2. Using 'Home Manager' as my only package manager will cause inconvenience which means I have to install nix first on normal linux distro, such as arch and fedora. Using both manager is inconvenient too.

    So, I only use `Home Manager` to manage packages to be installed. Another key fact is, NixOS is declarative, so we should avoid using the `run_*` scripts on NixOS, but using `Home Manager` to manage.
