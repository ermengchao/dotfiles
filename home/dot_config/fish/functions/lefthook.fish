function lefthook --description 'Run Lefthook or deploy a service template'
    if test "$argv[1]" != deploy
        command lefthook $argv
        return $status
    end

    if test (count $argv) -ne 2
        printf 'Usage: lefthook deploy <service>\n' >&2
        return 2
    end

    set -l service "$argv[2]"
    switch "$service"
        case '' . .. '*/*'
            printf 'lefthook deploy: invalid service name: %s\n' "$service" >&2
            return 2
    end

    set -l config_home "$XDG_CONFIG_HOME"
    if test -z "$config_home"
        set config_home "$HOME/.config"
    end

    set -l template_dir "$config_home/lefthook/$service"
    set -l config "$template_dir/lefthook.yml"
    set -l hooks "$template_dir/.lefthook"
    set -l legacy_script "$template_dir/ai-commit-message.fish"

    if not test -f "$config"
        printf 'lefthook deploy: template not found: %s\n' "$config" >&2
        return 1
    end

    if not test -d "$hooks"
        if test "$service" != ai-commit-message; or not test -f "$legacy_script"
            printf 'lefthook deploy: template directory not found: %s\n' "$hooks" >&2
            return 1
        end
    end

    for destination in lefthook.yml .lefthook
        if test -e "$destination"; or test -L "$destination"
            printf 'lefthook deploy: %s already exists\n' "$destination" >&2
            return 1
        end
    end

    mkdir ./.lefthook; or return $status
    if test -d "$hooks"
        cp -R "$hooks/." ./.lefthook
    else
        mkdir ./.lefthook/prepare-commit-msg
        and cp "$legacy_script" ./.lefthook/prepare-commit-msg/
    end
    and set -l staged_config (mktemp ./.lefthook/lefthook.yml.XXXXXXXX)
    and cp -p "$config" "$staged_config"
    and mv -n "$staged_config" ./lefthook.yml
    and not test -e "$staged_config"
    or begin
        rm -rf ./.lefthook
        printf 'lefthook deploy: could not deploy %s\n' "$service" >&2
        return 1
    end
end
