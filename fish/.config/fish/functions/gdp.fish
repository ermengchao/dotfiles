function gdp --description "Create package.json from template"
    set template ~/.config/fish/templates/package.json

    if test -e package.json
        echo "package.json already exists" >&2
        return 1
    end

    if not test -e $template
        echo "Template not found: $template" >&2
        return 1
    end

    cp $template ./package.json
    echo "Created package.json from template."
end
