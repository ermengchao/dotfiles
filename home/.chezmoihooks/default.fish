#!/usr/bin/env fish

set self (realpath (status filename))
set current_dir (dirname $self)
set parent_dir (dirname $current_dir)

chmod +x $parent_dir

for script in (find $current_dir -type f -name "*.fish")
    set script_path (realpath $script)
    set script_name (basename $script)

    if test "$script_path" != "$self"
        printf "Executing chezmoi's hook: $script_name...\n"
        fish $script_path
    end
end
