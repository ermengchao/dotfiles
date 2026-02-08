#!/usr/bin/env fish

if type -q sing-box
    cd $XDG_CONFIG_HOME/sing-box
    set config_fields ./config

    if test -d $config_fields
        sing-box merge config.json -C $config_fields 2>/dev/null
    end
end
