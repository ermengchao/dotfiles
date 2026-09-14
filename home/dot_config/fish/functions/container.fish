set -g _container_install_content "[Install]
WantedBy=default.target
"

function _container_usage
    printf '%s\n' \
        'Usage:' \
        '  container enable [--user] NAME' \
        '  container disable [--user] NAME' \
        '  container CONTAINER-CLI-ARGUMENTS...'
end

function _container_normalize_unit_name --argument-names name
    if string match -rq '\.(container|volume|network|pod|kube|image|build|artifact)$' -- "$name"
        printf '%s\n' "$name"
    else
        printf '%s.container\n' "$name"
    end
end

function _container_user_unit_source --argument-names unit_name
    set -l rows (command podman quadlet list --noheading --format '{{.Name}}	{{.Path}}')
    if test $status -ne 0
        printf 'container: podman quadlet list failed\n' >&2
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
        printf 'container: user unit %s was not found by podman\n' "$unit_name" >&2
        return 1
    else if test (count $matches) -gt 1
        printf 'container: multiple user units named %s were found:\n' "$unit_name" >&2
        printf '  %s\n' $matches >&2
        return 1
    end

    printf '%s\n' "$matches[1]"
end

function _container_system_unit_source --argument-names unit_name
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
        printf 'container: system unit %s was not found below %s\n' "$unit_name" "$base" >&2
        return 1
    else if test (count $matches) -gt 1
        printf 'container: multiple system units named %s were found:\n' "$unit_name" >&2
        printf '  %s\n' $matches >&2
        return 1
    end

    printf '%s\n' "$matches[1]"
end

function _container_dropin_file --argument-names source
    printf '%s.d/install.conf\n' "$source"
end

function _container_linux_enable --argument-names user_mode name
    set -l unit_name (_container_normalize_unit_name "$name")
    set -l source
    if test "$user_mode" = 1
        set source (_container_user_unit_source "$unit_name")
    else
        set source (_container_system_unit_source "$unit_name")
    end
    or return $status

    set -l install_file (_container_dropin_file "$source")
    set -l install_dir (path dirname "$install_file")

    if test -e "$install_file"
        set -l current (string collect -N <"$install_file")
        if test "$current" = "$_container_install_content"
            printf 'Already enabled: %s\n' "$install_file"
            return 0
        end
        printf 'container: refusing to overwrite existing %s\n' "$install_file" >&2
        return 1
    end

    if test "$user_mode" = 1; or test (id -u) -eq 0
        command mkdir -p -- "$install_dir"; or return
        printf '%s' "$_container_install_content" >"$install_file"; or return
    else
        set -l temp_file (mktemp)
        or return
        printf '%s' "$_container_install_content" >"$temp_file"
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

function _container_find_dropin --argument-names user_mode unit_name
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
        printf 'container: no drop-in directory found for %s below %s\n' "$unit_name" "$base" >&2
        return 1
    else if test (count $matches) -gt 1
        printf 'container: multiple drop-in directories found for %s:\n' "$unit_name" >&2
        printf '  %s\n' $matches >&2
        return 1
    end

    printf '%s\n' "$matches[1]"
end

function _container_linux_disable --argument-names user_mode name
    set -l unit_name (_container_normalize_unit_name "$name")
    set -l install_dir (_container_find_dropin "$user_mode" "$unit_name")
    or return $status
    set -l install_file "$install_dir/install.conf"

    if not test -f "$install_file"
        printf 'container: %s does not exist\n' "$install_file" >&2
        return 1
    end

    set -l current (string collect -N <"$install_file")
    if test "$current" != "$_container_install_content"
        printf 'container: refusing to remove modified %s\n' "$install_file" >&2
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

function _container_xml_escape --argument-names value
    string replace -a '&' '&amp;' -- "$value" \
        | string replace -a '<' '&lt;' \
        | string replace -a '>' '&gt;' \
        | string replace -a '"' '&quot;' \
        | string replace -a "'" '&apos;'
end

function _container_macos_validate_name --argument-names name
    if not string match -rq '^[A-Za-z0-9][A-Za-z0-9_.-]*$' -- "$name"
        printf 'container: invalid container name: %s\n' "$name" >&2
        return 2
    end
end

function _container_macos_exists --argument-names name
    set -l names (command container list --all --quiet)
    if test $status -ne 0
        printf 'container: container list --all --quiet failed\n' >&2
        return 1
    end

    if not contains -- "$name" $names
        printf 'container: created container %s was not found\n' "$name" >&2
        return 1
    end
end

function _container_launch_agent_label --argument-names name
    set -l safe_name (string replace -ra '[^A-Za-z0-9.-]' '-' -- "$name")
    printf 'local.container.%s\n' "$safe_name"
end

function _container_launch_agent_file --argument-names name
    set -l label (_container_launch_agent_label "$name")
    printf '%s/Library/LaunchAgents/%s.plist\n' "$HOME" "$label"
end

function _container_launch_agent_content --argument-names name
    set -l label (_container_xml_escape (_container_launch_agent_label "$name"))
    set -l escaped_name (_container_xml_escape "$name")
    set -l escaped_path (_container_xml_escape (string join : -- $PATH))

    printf '%s\n' \
        '<?xml version="1.0" encoding="UTF-8"?>' \
        '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' \
        '<plist version="1.0">' \
        '<dict>' \
        '    <!-- Managed by container.fish -->' \
        '    <key>Label</key>' \
        "    <string>$label</string>" \
        '    <key>ProgramArguments</key>' \
        '    <array>' \
        '        <string>/usr/bin/env</string>' \
        '        <string>container</string>' \
        '        <string>start</string>' \
        "        <string>$escaped_name</string>" \
        '    </array>' \
        '    <key>EnvironmentVariables</key>' \
        '    <dict>' \
        '        <key>PATH</key>' \
        "        <string>$escaped_path</string>" \
        '    </dict>' \
        '    <key>ProcessType</key>' \
        '    <string>Background</string>' \
        '    <key>RunAtLoad</key>' \
        '    <true/>' \
        '</dict>' \
        '</plist>'
end

function _container_macos_enable --argument-names name
    _container_macos_validate_name "$name"; or return
    _container_macos_exists "$name"; or return

    set -l label (_container_launch_agent_label "$name")
    set -l agent_file (_container_launch_agent_file "$name")
    set -l agent_dir (path dirname "$agent_file")
    set -l content (_container_launch_agent_content "$name" | string collect -N)
    set -l changed 1

    if test -e "$agent_file"
        if not test -f "$agent_file"
            printf 'container: refusing to replace non-file %s\n' "$agent_file" >&2
            return 1
        end
        set -l current (string collect -N <"$agent_file")
        if not string match -q '*Managed by container.fish*' -- "$current"
            printf 'container: refusing to overwrite unmanaged %s\n' "$agent_file" >&2
            return 1
        end
        if test "$current" = "$content"
            set changed 0
        end
    end

    if test $changed -eq 1
        command mkdir -p -- "$agent_dir"; or return
        set -l temp_file (mktemp "$agent_dir/.container.XXXXXX")
        or return
        printf '%s' "$content" >"$temp_file"
        and command chmod 0644 "$temp_file"
        and command mv -f "$temp_file" "$agent_file"
        set -l write_status $status
        if test -e "$temp_file"
            command rm -f -- "$temp_file"
        end
        test $write_status -eq 0; or return $write_status
    end

    set -l domain "gui/"(id -u)
    if command launchctl print "$domain/$label" >/dev/null 2>&1
        if test $changed -eq 0
            printf 'Already enabled: %s\n' "$agent_file"
            return 0
        end
        command launchctl bootout "$domain" "$agent_file" >/dev/null 2>&1
    end

    command launchctl bootstrap "$domain" "$agent_file"; or return
    printf 'Enabled: %s\n' "$agent_file"
end

function _container_macos_disable --argument-names name
    _container_macos_validate_name "$name"; or return

    set -l agent_file (_container_launch_agent_file "$name")
    if not test -e "$agent_file"
        printf 'Already disabled: %s\n' "$agent_file"
        return 0
    end
    if not test -f "$agent_file"
        printf 'container: refusing to remove non-file %s\n' "$agent_file" >&2
        return 1
    end

    set -l current (string collect -N <"$agent_file")
    if not string match -q '*Managed by container.fish*' -- "$current"
        printf 'container: refusing to remove unmanaged %s\n' "$agent_file" >&2
        return 1
    end

    set -l domain "gui/"(id -u)
    command launchctl bootout "$domain" "$agent_file" >/dev/null 2>&1
    command rm -- "$agent_file"; or return
    printf 'Disabled: %s\n' "$agent_file"
end

function container
    if test (count $argv) -gt 0; and contains -- "$argv[1]" enable disable
        set -l action "$argv[1]"
        set -e argv[1]
        set -l user_mode 0

        if test (count $argv) -gt 0; and contains -- "$argv[1]" --user -user
            set user_mode 1
            set -e argv[1]
        end

        if test (count $argv) -ne 1
            _container_usage >&2
            return 2
        end

        if test (uname -s) = Darwin
            if test "$action" = enable
                _container_macos_enable "$argv[1]"
            else
                _container_macos_disable "$argv[1]"
            end
        else if test "$action" = enable
            _container_linux_enable "$user_mode" "$argv[1]"
        else
            _container_linux_disable "$user_mode" "$argv[1]"
        end
        return $status
    end

    command container $argv
end
