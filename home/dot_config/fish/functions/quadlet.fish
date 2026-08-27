#!/usr/bin/env fish

set -g _quadlet_install_content "[Install]
WantedBy=default.target
"

function _quadlet_usage
    printf '%s\n' \
        'Usage:' \
        '  quadlet enable [--user] NAME' \
        '  quadlet disable [--user] NAME' \
        '  quadlet OTHER-QUADLET-ARGUMENTS...'
end

function _quadlet_normalize_name --argument-names name
    if string match -rq '\.(container|volume|network|pod|kube|image|build|artifact)$' -- "$name"
        printf '%s\n' "$name"
    else
        printf '%s.container\n' "$name"
    end
end

function _quadlet_user_source --argument-names unit_name
    if not type -q podman
        printf 'quadlet: podman is required for --user lookup\n' >&2
        return 127
    end

    set -l rows (command podman quadlet list --noheading --format '{{.Name}}	{{.Path}}')
    if test $status -ne 0
        printf 'quadlet: podman quadlet list failed\n' >&2
        return 1
    end

    set -l tab (printf '\t')
    set -l matches
    for row in $rows
        set -l fields (string split -m 1 -- "$tab" "$row")
        if test (count $fields) -eq 2; and test "$fields[1]" = "$unit_name"
            set -a matches "$fields[2]"
        end
    end

    if test (count $matches) -eq 0
        printf 'quadlet: user Quadlet %s was not found by podman\n' "$unit_name" >&2
        return 1
    else if test (count $matches) -gt 1
        printf 'quadlet: multiple user Quadlets named %s were found:\n' "$unit_name" >&2
        printf '  %s\n' $matches >&2
        return 1
    end

    printf '%s\n' "$matches[1]"
end

function _quadlet_system_source --argument-names unit_name
    set -l base /etc/containers/systemd
    set -l matches

    if test -f "$base/$unit_name"
        set -a matches "$base/$unit_name"
    end
    if test -d "$base"
        for candidate in "$base"/**/"$unit_name"
            if test -f "$candidate"; and not contains -- "$candidate" $matches
                set -a matches "$candidate"
            end
        end
    end

    if test (count $matches) -eq 0
        printf 'quadlet: system Quadlet %s was not found below %s\n' "$unit_name" "$base" >&2
        return 1
    else if test (count $matches) -gt 1
        printf 'quadlet: multiple system Quadlets named %s were found:\n' "$unit_name" >&2
        printf '  %s\n' $matches >&2
        return 1
    end

    printf '%s\n' "$matches[1]"
end

function _quadlet_dropin_from_source --argument-names source
    printf '%s.d/install.conf\n' "$source"
end

function _quadlet_enable --argument-names user_mode name
    set -l unit_name (_quadlet_normalize_name "$name")
    set -l source
    if test "$user_mode" = 1
        set source (_quadlet_user_source "$unit_name")
    else
        set source (_quadlet_system_source "$unit_name")
    end
    or return $status

    set -l install_file (_quadlet_dropin_from_source "$source")
    set -l install_dir (path dirname "$install_file")

    if test -e "$install_file"
        set -l current (string collect -N <"$install_file")
        if test "$current" = "$_quadlet_install_content"
            printf 'Already enabled: %s\n' "$install_file"
            return 0
        end
        printf 'quadlet: refusing to overwrite existing %s\n' "$install_file" >&2
        return 1
    end

    if test "$user_mode" = 1; or test (id -u) -eq 0
        command mkdir -p -- "$install_dir"; or return
        printf '%s' "$_quadlet_install_content" >"$install_file"; or return
    else
        set -l temp_file (mktemp)
        or return
        printf '%s' "$_quadlet_install_content" >"$temp_file"
        or begin
            command rm -f -- "$temp_file"
            return 1
        end
        command sudo install -d -m 0755 -- "$install_dir"
        and command sudo install -m 0644 -- "$temp_file" "$install_file"
        set -l write_status $status
        command rm -f -- "$temp_file"
        test $write_status -eq 0; or return $write_status
    end

    printf 'Enabled: %s\n' "$install_file"
end

function _quadlet_find_dropin --argument-names user_mode unit_name
    set -l base
    if test "$user_mode" = 1
        set base "$HOME/.config/containers/systemd"
    else
        set base /etc/containers/systemd
    end

    set -l matches
    set -l dirname "$unit_name.d"
    if test -d "$base/$dirname"
        set -a matches "$base/$dirname"
    end
    if test -d "$base"
        for candidate in "$base"/**/"$dirname"
            if test -d "$candidate"; and not contains -- "$candidate" $matches
                set -a matches "$candidate"
            end
        end
    end

    if test (count $matches) -eq 0
        printf 'quadlet: no drop-in directory found for %s below %s\n' "$unit_name" "$base" >&2
        return 1
    else if test (count $matches) -gt 1
        printf 'quadlet: multiple drop-in directories found for %s:\n' "$unit_name" >&2
        printf '  %s\n' $matches >&2
        return 1
    end

    printf '%s\n' "$matches[1]"
end

function _quadlet_disable --argument-names user_mode name
    set -l unit_name (_quadlet_normalize_name "$name")
    set -l install_dir (_quadlet_find_dropin "$user_mode" "$unit_name")
    or return $status
    set -l install_file "$install_dir/install.conf"

    if not test -f "$install_file"
        printf 'quadlet: %s does not exist\n' "$install_file" >&2
        return 1
    end

    set -l current (string collect -N <"$install_file")
    if test "$current" != "$_quadlet_install_content"
        printf 'quadlet: refusing to remove modified %s\n' "$install_file" >&2
        return 1
    end

    set -l entries (command ls -A -- "$install_dir")
    set -l remove_dir 0
    if test (count $entries) -eq 1; and test "$entries[1]" = install.conf
        set remove_dir 1
    end

    if test "$user_mode" = 1; or test (id -u) -eq 0
        if test $remove_dir -eq 1
            command rm -- "$install_file"; and command rmdir -- "$install_dir"
        else
            command rm -- "$install_file"
        end
    else
        if test $remove_dir -eq 1
            command sudo rm -- "$install_file"; and command sudo rmdir -- "$install_dir"
        else
            command sudo rm -- "$install_file"
        end
    end
    or return

    printf 'Disabled: %s\n' "$install_file"
end

function quadlet
    if test (count $argv) -gt 0; and contains -- "$argv[1]" enable disable
        set -l action "$argv[1]"
        set -e argv[1]
        set -l user_mode 0

        if test (count $argv) -gt 0; and contains -- "$argv[1]" --user -user
            set user_mode 1
            set -e argv[1]
        end

        if test (count $argv) -ne 1
            _quadlet_usage >&2
            return 2
        end

        if test "$action" = enable
            _quadlet_enable "$user_mode" "$argv[1]"
        else
            _quadlet_disable "$user_mode" "$argv[1]"
        end
        return $status
    end

    command quadlet $argv
end
