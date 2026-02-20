function glc --description "Create lefthook.yml from template"
    set template ~/.config/fish/templates/lefthook.yml

    if test -e lefthook.yml
        echo "lefthook.yml already exists" >&2
        return 1
    end

    if not test -e $template
        echo "Template not found: $template" >&2
        return 1
    end

    cp $template ./lefthook.yml
    echo "Created lefthook.yml from template."
end
